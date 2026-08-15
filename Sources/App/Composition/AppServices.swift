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
    let launcher: any ApplicationLaunchPort = WorkspaceApplicationLauncher()

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
        order.note(entryIds: registry.taskbarEntries.map { WindowEntryIdentifier.text(for: $0.identity) })
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

    func activate(entry: TaskbarEntryModel) {
        guard !entry.isLauncher else {
            entry.bundleIdentifier.map(launcher.launch(bundleIdentifier:))
            return
        }
        toggle(entryId: entry.id)
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
            icons: icons,
            displaySource: displays,
            onActivate: { [weak self] entry in self?.activate(entry: entry) },
            onRequestAccessibility: { [authorization] in authorization.requestTrust() },
            onOpenStart: {},
            onTogglePin: { [weak self] entry in self?.togglePin(entry: entry) },
            onDropPin: { [weak self] dropped, target in
                self?.movePin(bundleIdentifier: dropped, before: target)
            }
        )
        host.present(preset: preset)
        bar = host
    }

    private let store: KcdBarStore?
}
