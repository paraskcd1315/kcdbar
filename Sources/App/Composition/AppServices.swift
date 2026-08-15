import Foundation

/** The composition root, and the only place naming a concrete platform implementation. */
@MainActor
final class AppServices {
    let icons: any ApplicationIconPort = WorkspaceIconSource()
    let displays: any DisplayGeometryPort = ScreenGeometrySource()
    let authorization: any AccessibilityAuthorizationPort = AccessibilityAuthorization()
    let changes: any WindowChangeObserverPort = WorkspaceWindowChangeObserver()
    let registry: WindowRegistry
    let pins: PinnedAppState
    let order = EntryOrderMemory()
    let desktop = ShowDesktopState()
    let showDesktop: any ShowDesktopPort = CoreDockShowDesktop()
    let launcher: any ApplicationLaunchPort = WorkspaceApplicationLauncher()
    let newWindow: any NewWindowPort = AccessibilityNewWindow()

    let control: any WindowControlPort = AccessibilityWindowControl()
    let geometry: any WindowGeometryObserverPort = AccessibilityGeometryObserver()
    private lazy var overlap = WindowOverlapEnforcer(control: control)
    private var activePreset = BarPresetCatalogue.default
    private lazy var coalesced = CoalescedTrigger(
        interval: WindowOverlapMetrics.coalesceInterval
    ) { [weak self] in
        self?.refreshAndEnforce()
    }

    private(set) var bar: (any BarPanelHostPort)?

    func scheduleRefresh() {
        coalesced.fire()
    }

    func refreshAndEnforce(now: Date = Date()) {
        registry.refresh()
        overlap.enforce(
            preset: activePreset,
            windows: registry.windows,
            displays: registry.displays,
            now: now
        )
        order.note(keys: orderingKeys)
        geometry.observe(pids: observedPids) { [weak self] in
            self?.scheduleRefresh()
        }
    }

    func stopObserving() {
        coalesced.cancel()
        geometry.stop()
        changes.stopObserving()
    }

    private var observedPids: [pid_t] {
        Array(Set(registry.windows.map(\.ownerPid)))
    }

    private var orderingKeys: [String] {
        let pinnedIdentifiers = Set(pins.apps.map(\.bundleIdentifier))
        let windowKeys = registry.taskbarEntries.map { window -> String in
            let bundleIdentifier = registry.bundleIdentifiers[window.ownerPid]
            return TaskbarOrdering.orderingKey(
                bundleIdentifier: bundleIdentifier,
                entryId: WindowEntryIdentifier.text(for: window.identity),
                isPinned: bundleIdentifier.map(pinnedIdentifiers.contains) ?? false
            )
        }
        let launcherKeys = pins.apps.map { "pin:\($0.bundleIdentifier)" }
        let entryIds = registry.taskbarEntries.map { WindowEntryIdentifier.text(for: $0.identity) }
        let all = launcherKeys + windowKeys + entryIds

        return Array(NSOrderedSet(array: all)) as? [String] ?? all
    }

    func toggleShowDesktop() {
        if showDesktop.toggle() {
            desktop.setSystemShowingDesktop(!desktop.isShowingDesktop)
            return
        }
        if desktop.isShowingDesktop {
            restoreFromDesktop()
        } else {
            hideToDesktop()
        }
        refreshAndEnforce()
    }

    private func hideToDesktop() {
        let visible = registry.taskbarEntries.filter { !$0.isMinimized }
        for window in visible {
            _ = control.perform(.minimize, on: window)
        }
        desktop.remember(keys: visible.map { WindowEntryIdentifier.text(for: $0.identity) })
    }

    private func restoreFromDesktop() {
        let wanted = Set(desktop.hiddenKeys)
        for window in registry.windows
        where wanted.contains(WindowEntryIdentifier.text(for: window.identity)) {
            _ = control.perform(.restore, on: window)
        }
        desktop.clear()
    }

    func reorder(draggedKey: String, before target: TaskbarEntryModel) {
        order.move(key: draggedKey, before: target.orderingKey)
        persistPinnedOrder()
    }

    private func persistPinnedOrder() {
        let pinnedByKey = Dictionary(
            uniqueKeysWithValues: pins.apps.map { ("pin:\($0.bundleIdentifier)", $0) }
        )
        let ordered = order.keys.compactMap { pinnedByKey[$0] }
        guard ordered.count == pins.apps.count else { return }

        Task { await pins.reorder(ordered) }
    }

    func toggle(entryId: String) {
        guard let window = registry.window(withEntryId: entryId) else { return }
        let action = WindowToggleDecider.action(
            for: window,
            frontmostPid: registry.frontmostPid,
            among: registry.windows
        )
        _ = control.perform(action, on: window)
        refreshAndEnforce()
    }

    init() {
        registry = WindowRegistry(
            coreGraphicsSource: CoreGraphicsWindowSource(),
            accessibilitySource: AccessibilityWindowSource(),
            applicationsSource: WorkspaceApplicationsSource(),
            displaySource: ScreenGeometrySource(),
            authorization: AccessibilityAuthorization()
        )
        let container = KcdBarStore.opened()
        store = container.map { KcdBarStore(modelContainer: $0) }
        pins = PinnedAppState(store: store ?? EphemeralPinnedAppStore())
    }

    func loadPreferences() async {
        await pins.load()
    }

    func activate(entry: TaskbarEntryModel, onDisplay displayId: Int) {
        guard entry.isLauncher else {
            toggle(entryId: entry.id)
            return
        }
        guard let bundleIdentifier = entry.bundleIdentifier else { return }

        if openNewWindowElsewhere(bundleIdentifier: bundleIdentifier, displayId: displayId) {
            return
        }
        launcher.launch(bundleIdentifier: bundleIdentifier)
    }

    func openNewInstance(entry: TaskbarEntryModel, onDisplay displayId: Int) {
        guard let bundleIdentifier = entry.bundleIdentifier else { return }
        guard let pid = registry.bundleIdentifiers.first(where: { $0.value == bundleIdentifier })?.key,
              let display = registry.displays.first(where: { $0.id == displayId }),
              newWindow.supportsNewWindow(pid: pid)
        else {
            launcher.launch(bundleIdentifier: bundleIdentifier)
            return
        }
        _ = newWindow.openNewWindow(pid: pid, placingOn: display.frame)
        scheduleRefresh()
    }

    private func openNewWindowElsewhere(bundleIdentifier: String, displayId: Int) -> Bool {
        let pids = registry.bundleIdentifiers
            .filter { $0.value == bundleIdentifier }
            .map(\.key)
        guard let pid = pids.first,
              let display = registry.displays.first(where: { $0.id == displayId }),
              newWindow.supportsNewWindow(pid: pid)
        else {
            return false
        }
        let alreadyHere = registry.taskbarEntries.contains { window in
            window.ownerPid == pid
                && WindowDisplayResolver.displayId(for: window, in: registry.displays) == displayId
        }
        guard !alreadyHere else { return false }

        let opened = newWindow.openNewWindow(pid: pid, placingOn: display.frame)
        if opened {
            scheduleRefresh()
        }
        return opened
    }

    func togglePin(entry: TaskbarEntryModel) {
        guard let bundleIdentifier = entry.bundleIdentifier else { return }
        let name = entry.applicationName.isEmpty ? bundleIdentifier : entry.applicationName

        Task {
            if entry.isPinned {
                await pins.unpin(bundleIdentifier: bundleIdentifier)
            } else {
                await pins.pin(bundleIdentifier: bundleIdentifier, displayName: name)
            }
        }
    }

    func movePin(bundleIdentifier: String, before target: TaskbarEntryModel) {
        Task {
            await pins.move(bundleIdentifier: bundleIdentifier, before: target.bundleIdentifier)
        }
    }

    func startBar(preset: BarPreset) {
        activePreset = preset
        let host = BarPanelHost(
            registry: registry,
            pins: pins,
            order: order,
            desktop: desktop,
            icons: icons,
            displaySource: displays,
            onActivate: { [weak self] entry, displayId in
                self?.activate(entry: entry, onDisplay: displayId)
            },
            onRequestAccessibility: { [authorization] in authorization.requestTrust() },
            onOpenStart: {},
            onTogglePin: { [weak self] entry in self?.togglePin(entry: entry) },
            onDropPin: { [weak self] dropped, target in
                self?.reorder(draggedKey: dropped, before: target)
            },
            onToggleDesktop: { [weak self] in self?.toggleShowDesktop() },
            onMiddleClick: { [weak self] entry, displayId in
                self?.openNewInstance(entry: entry, onDisplay: displayId)
            }
        )
        host.present(preset: preset)
        bar = host
    }

    private let store: KcdBarStore?
}
