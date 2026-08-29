import AppKit
import Foundation
import KcdBarPreferences
import KcdBarTaskbar
import KcdBarTray
import SwiftUI

/** The composition root, and the only place naming a concrete platform implementation. */
@MainActor
package final class AppServices {
    package let icons: any ApplicationIconPort = WorkspaceIconSource()
    package let displays: any DisplayGeometryPort = ScreenGeometrySource()
    package let authorization: any AccessibilityAuthorizationPort = AccessibilityAuthorization()
    package let changes: any WindowChangeObserverPort = WorkspaceWindowChangeObserver()
    package let registry: WindowRegistry
    package let battery = BatteryMonitor(source: IoKitBatterySource())
    package let popover = PopoverHost()
    package let wifi = WifiMonitor(
        source: CoreWlanSource(),
        links: SystemConfigurationLinkSource()
    )
    package let trash = TrashMonitor(
        source: FileManagerTrashSource(),
        confirmation: AlertTrashConfirmation()
    )
    package let timer = TimerMonitor(
        source: KcdSignalTimerSource(),
        tickets: ConsoleTicketOpener()
    )
    package let totals = TotalsMonitor(source: KcdSignalTotalsSource())
    package let day = DayMonitor(
        source: KcdSignalDaySource(),
        tickets: ConsoleTicketOpener()
    )
    package let sessions = SessionsMonitor(
        source: KcdSignalSessionsSource(),
        panes: TmuxPaneFocus()
    )
    package let previews = TaskbarPreviewState(port: ScreenCaptureWindowPreviewSource())
    package let loginItem = LoginItemState(port: ServiceManagementLoginItem())
    package let stageManager = StageManagerState(port: WindowManagerStageManager())
    package let bluetooth = BluetoothMonitor(source: IoBluetoothSource())
    package let sound = SoundMonitor(source: CoreAudioSoundSource())
    package let brightness = BrightnessMonitor(source: DisplayServicesBrightness())
    package let settings: BarSettingsState
    package let pins: PinnedAppState
    package let exclusions: QuitExclusionState
    package let dock: DockSuppressionState
    package let startPins: PinnedAppState
    package let startGroups: StartGroupState
    package let panelEditor: any PanelTextEditingPort = AppKitPanelTextEditing()
    package let applications: ApplicationCatalogueState
    package let usage: ApplicationUsageState
    package let order = EntryOrderMemory()
    package let desktop = ShowDesktopState()
    package let showDesktop: any ShowDesktopPort = CoreDockShowDesktop()
    package let launcher: any ApplicationLaunchPort = WorkspaceApplicationLauncher()
    package let terminator: any ApplicationTerminationPort = WorkspaceApplicationTerminator()
    package let spotlight: any SpotlightPort = CgEventSpotlight()
    package let pasteboard: any PasteboardPort = AppKitPasteboard()
    package let newWindow: any NewWindowPort = AccessibilityNewWindow()
    package let menuExtras: any SystemMenuExtraPort = AccessibilitySystemMenuExtras()
    package let power: any PowerActionPort = LoginWindowPowerControl()
    package let userPicture: any UserPicturePort = CollaborationUserPicture()
    package let settingsWindow = SettingsWindowHost()
    package let aboutWindow = AboutWindowHost()

    package let control: any WindowControlPort = AccessibilityWindowControl()
    package let spaces: any WindowSpaceFocusPort = SkyLightSpaceFocus()
    package let geometry: any WindowGeometryObserverPort = AccessibilityGeometryObserver()
    private lazy var overlap = WindowOverlapEnforcer(control: control)
    private lazy var solo = SoloWindowEnforcer(control: control)
    private lazy var lastWindow = LastWindowQuitEnforcer(
        terminator: terminator,
        menuExtras: AccessibilityMenuExtraOwnership(),
        isEnabled: { [weak self] in self?.activePreset.quitsOnLastWindow ?? false },
        excluded: { [weak self] in self?.exclusions.bundleIdentifiers ?? [] }
    )
    private var activePreset = BarPresetCatalogue.default
    private var lastReading: BarRefreshReading?
    private lazy var coalesced = CoalescedTrigger(
        interval: WindowOverlapMetrics.coalesceInterval
    ) { [weak self] in
        self?.requestRefresh()
    }

    package private(set) var bar: (any BarPanelHostPort)?

    package func scheduleRefresh() {
        coalesced.fire()
    }

    private func noteRefresh() {
        let reading = BarRefreshReading(
            windows: registry.taskbarEntries.count,
            applications: registry.applications.count,
            trusted: registry.hasAccessibility,
            preset: activePreset.name,
            battery: battery.state.isPresent
        )
        guard reading != lastReading else { return }

        lastReading = reading
        BarLog.bar.notice("""
            refresh windows=\(reading.windows) apps=\(reading.applications) \
            trusted=\(reading.trusted) preset=\(reading.preset, privacy: .public) battery=\(reading.battery)
            """)
    }

    package func requestRefresh() {
        Task { await refreshAndEnforce() }
    }

    package func refreshAndEnforce() async {
        await registry.refresh()
        let now = Date()
        battery.refresh()
        overlap.enforce(
            preset: activePreset,
            windows: registry.taskbarEntries,
            displays: registry.displays,
            now: now
        )
        solo.enforce(
            frontmostPid: registry.frontmostPid,
            windows: registry.taskbarEntries,
            displays: registry.displays,
            now: now
        )
        for decision in lastWindow.enforce(
            windows: registry.windows, applications: registry.applications, now: now)
        {
            BarLog.bar.notice("""
                lastWindow bundle=\(decision.application.bundleIdentifier ?? "?", privacy: .public) \
                verdict=\(decision.verdict.rawValue, privacy: .public)
                """)
        }
        order.note(keys: orderingKeys)
        noteRefresh()
        bar?.syncVisibility()
        geometry.observe(pids: observedPids) { [weak self] in
            self?.scheduleRefresh()
        }
    }

    package func stopObserving() {
        coalesced.cancel()
        geometry.stop()
        changes.stopObserving()
    }

    private var observedPids: [pid_t] {
        Array(Set(registry.windows.map(\.ownerPid)))
    }

    private var orderingKeys: [String] {
        let windowKeys = registry.taskbarEntries.map { window -> String in
            TaskbarOrdering.orderingKey(
                bundleIdentifier: registry.bundleIdentifiers[window.ownerPid],
                entryId: WindowEntryIdentifier.text(for: window.identity)
            )
        }
        let launcherKeys = pins.apps.map { TaskbarOrdering.applicationKey($0.bundleIdentifier) }
        let entryIds = ShowDesktopPlan.keys(of: registry.taskbarEntries)

        return OrderedKeys.deduped(launcherKeys + windowKeys + entryIds)
    }

    package func toggleShowDesktop() {
        if showDesktop.toggle() {
            desktop.setSystemShowingDesktop(!desktop.isShowingDesktop)
            return
        }
        if desktop.isShowingDesktop {
            restoreFromDesktop()
        } else {
            hideToDesktop()
        }
        requestRefresh()
    }

    private func hideToDesktop() {
        let visible = ShowDesktopPlan.toHide(among: registry.taskbarEntries)
        for window in visible {
            _ = control.perform(.minimize, on: window)
        }
        desktop.remember(keys: ShowDesktopPlan.keys(of: visible))
    }

    private func restoreFromDesktop() {
        let wanted = ShowDesktopPlan.toRestore(
            among: registry.windows,
            hiddenKeys: desktop.hiddenKeys
        )
        for window in wanted {
            _ = control.perform(.restore, on: window)
        }
        desktop.clear()
    }

    package func reorder(draggedKey: String, onto target: TaskbarEntryModel) {
        order.move(key: draggedKey, onto: target.orderingKey)
        persistPinnedOrder()
    }

    private func persistPinnedOrder() {
        guard let ordered = PinnedOrder.reordered(pins.apps, byKeys: order.keys) else { return }

        Task { await pins.reorder(ordered) }
    }

    package func toggle(entryId: String) {
        guard let window = registry.window(withEntryId: entryId) else { return }
        let action = WindowToggleDecider.action(
            for: window,
            frontmostPid: registry.frontmostPid,
            among: registry.windows
        )
        _ = control.perform(action, on: window)
        requestRefresh()
    }

    package init() {
        registry = WindowRegistry(
            coreGraphicsSource: CoreGraphicsWindowSource(),
            accessibilitySource: AccessibilityWindowSource(),
            applicationsSource: WorkspaceApplicationsSource(),
            displaySource: ScreenGeometrySource(),
            authorization: AccessibilityAuthorization(),
            spaces: SkyLightWindowSpaces()
        )
        let opened = PreferencesStore.opened()
        store = opened
        settings = BarSettingsState(store: opened)
        pins = PinnedAppState(store: opened)
        exclusions = QuitExclusionState(store: opened)
        dock = DockSuppressionState(
            control: UserDefaultsDockControl(dryRun: DockDryRunPreference.isEnabled),
            store: opened
        )
        startPins = PinnedAppState(store: StartPinStoreAdapter(store: opened))
        startGroups = StartGroupState(store: opened)
        usage = ApplicationUsageState(store: opened)

        let indexed = SpotlightApplicationSource()
        applications = ApplicationCatalogueState(
            catalogue: MergedApplicationSource([DirectoryApplicationSource(), indexed]),
            watcher: indexed
        )
    }

    /** Loads what the bar is drawn from, then raises it. */
    package func start() async {
        settings.observe { [weak self] preset in self?.apply(preset: preset) }
        await settings.load()
        await pins.load()
        await exclusions.load()
        await startPins.load()
        await usage.load()
        await dock.load()
        order.seed(keys: pins.apps.map { TaskbarOrdering.applicationKey($0.bundleIdentifier) })
        startBar(preset: settings.preset)
        await dock.apply(handling: settings.preset.dockHandling)
        await refreshAndEnforce()
    }

    package func activate(entry: TaskbarEntryModel, onDisplay displayId: Int) {
        guard entry.isLauncher else {
            toggle(entryId: entry.id)
            return
        }
        guard let bundleIdentifier = entry.bundleIdentifier else { return }
        guard let window = LauncherWindowCycle.next(
            pids: pids(of: bundleIdentifier),
            onDisplay: displayId,
            among: registry.taskbarEntries,
            displays: registry.displays,
            frontmostPid: registry.frontmostPid
        )
        else {
            launcher.launch(bundleIdentifier: bundleIdentifier)
            usage.note(launchOf: bundleIdentifier)
            return
        }

        _ = control.perform(window.isMinimized ? .restore : .raise, on: window)
        requestRefresh()
    }

    private func pids(of bundleIdentifier: String) -> Set<pid_t> {
        Set(registry.bundleIdentifiers.filter { $0.value == bundleIdentifier }.map(\.key))
    }

    package func openNewInstance(entry: TaskbarEntryModel, onDisplay displayId: Int) {
        guard let bundleIdentifier = entry.bundleIdentifier else { return }
        guard let pid = registry.bundleIdentifiers.first(where: { $0.value == bundleIdentifier })?.key,
              let display = registry.displays.first(where: { $0.id == displayId }),
              newWindow.supportsNewWindow(pid: pid)
        else {
            launcher.launch(bundleIdentifier: bundleIdentifier)
            usage.note(launchOf: bundleIdentifier)
            return
        }
        _ = newWindow.openNewWindow(pid: pid, placingOn: display.frame)
        scheduleRefresh()
    }

    package func openBatteryPanel() {
        guard !popover.isPresenting(.battery) else {
            popover.dismiss()
            return
        }
        battery.refresh()
        popover.present(.battery, anchor: popoverAnchor()) { [battery] presentation, arrowX in
            BatteryPanelPresentation.content(
                monitor: battery,
                presentation: presentation,
                arrowX: arrowX
            )
        }
        Task { await battery.sampleEnergy() }
    }

    package func openDayPanel() {
        guard !popover.isPresenting(.day) else {
            popover.dismiss()
            return
        }

        popover.present(.day, anchor: popoverAnchor()) { [day] presentation, arrowX in
            DayPanelPresentation.content(
                monitor: day,
                presentation: presentation,
                arrowX: arrowX
            )
        }
    }

    package func openSessionsPanel() {
        guard !popover.isPresenting(.sessions) else {
            popover.dismiss()
            return
        }

        popover.present(.sessions, anchor: popoverAnchor()) { [sessions] presentation, arrowX in
            SessionsPanelPresentation.content(
                monitor: sessions,
                presentation: presentation,
                arrowX: arrowX
            )
        }
    }

    package func openStartMenu() {
        guard !popover.isPresenting(.start) else {
            popover.dismiss()
            return
        }

        popover.present(.start, anchor: popoverAnchor(), takesFocus: true) {
            [applications, usage, startPins, startGroups, panelEditor, icons, launcher, power, popover, spotlight, userPicture]
            presentation, arrowX in
            StartMenuPresentation.content(
                catalogue: applications,
                usage: usage,
                pinned: startPins,
                groups: startGroups,
                editor: panelEditor,
                icons: icons,
                userName: NSFullUserName(),
                avatar: userPicture.picture(),
                presentation: presentation,
                arrowX: arrowX,
                onLaunch: { [usage] identifier in
                    launcher.launch(bundleIdentifier: identifier)
                    usage.note(launchOf: identifier)
                },
                onTogglePin: { [weak self] in self?.toggleStartPin(bundleIdentifier: $0) },
                onPower: { action in
                    popover.dismiss()
                    _ = power.perform(action)
                },
                onSearch: {
                    popover.dismiss()
                    _ = spotlight.open()
                }
            )
        }
    }

    package func toggleStartPin(bundleIdentifier: String) {
        let name = applications.application(withBundleIdentifier: bundleIdentifier)?.displayName

        Task {
            if startPins.apps.contains(where: { $0.bundleIdentifier == bundleIdentifier }) {
                await startPins.unpin(bundleIdentifier: bundleIdentifier)
            } else {
                await startPins.pin(
                    bundleIdentifier: bundleIdentifier,
                    displayName: name ?? bundleIdentifier
                )
            }
        }
    }

    package func openControlCentre() {
        guard !popover.isPresenting(.controlCentre) else {
            popover.dismiss()
            return
        }
        wifi.refresh()
        bluetooth.refresh()
        sound.refresh()
        brightness.refresh()
        popover.present(.controlCentre, anchor: popoverAnchor()) {
            [wifi, bluetooth, sound, brightness, pasteboard] presentation, _ in
            ControlCentrePresentation.content(
                wifi: wifi,
                bluetooth: bluetooth,
                sound: sound,
                brightness: brightness,
                presentation: presentation,
                onOpenWifiSettings: { NSWorkspace.shared.open(BarSettingsLinks.wifi) },
                onOpenBluetoothSettings: { NSWorkspace.shared.open(BarSettingsLinks.bluetooth) },
                onOpenNetworkSettings: { NSWorkspace.shared.open(BarSettingsLinks.network) },
                onCopy: { [pasteboard] in pasteboard.copy($0) }
            )
        }
    }

    private func popoverAnchor() -> NSPoint {
        let pointer = NSEvent.mouseLocation
        guard let display = registry.displays.first(where: { $0.frame.contains(pointer) }) else {
            return pointer
        }

        return NSPoint(
            x: pointer.x,
            y: BarFrameCalculator.frame(for: activePreset, on: display).maxY
        )
    }

    package func closeWindow(entry: TaskbarEntryModel) {
        guard let window = registry.window(withEntryId: entry.id), control.close(window) else {
            return
        }
        scheduleRefresh()
    }

    package func quit(entry: TaskbarEntryModel) {
        guard let bundleIdentifier = entry.bundleIdentifier,
              ApplicationQuitPolicy.canQuit(bundleIdentifier: bundleIdentifier),
              terminator.quit(bundleIdentifier: bundleIdentifier)
        else {
            return
        }
        scheduleRefresh()
    }

    package func togglePin(entry: TaskbarEntryModel) {
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

    package func openSettings() {
        settingsWindow.present { [settings, loginItem, stageManager, exclusions, registry, timer] in
            SettingsRootView(
                settings: settings,
                loginItem: loginItem,
                stageManager: stageManager,
                exclusions: exclusions,
                runningApplications: registry.applications,
                isTrackingAvailable: timer.isAvailable
            )
        }
    }

    package func openAbout() {
        aboutWindow.present()
    }

    package func apply(preset: BarPreset) {
        guard preset != activePreset else { return }

        let handling = preset.dockHandling
        activePreset = preset
        bar?.present(preset: preset)
        requestRefresh()
        Task { [dock] in await dock.apply(handling: handling) }
    }

    package func restoreDock() async {
        await dock.restore()
    }

    package func startBar(preset: BarPreset) {
        activePreset = preset
        let host = BarPanelHost(
            registry: registry,
            battery: battery,
            trash: trash,
            timer: timer,
            totals: totals,
            sessions: sessions,
            previews: previews,
            pins: pins,
            order: order,
            desktop: desktop,
            icons: icons,
            displaySource: displays,
            onActivate: { [weak self] entry, displayId in
                self?.activate(entry: entry, onDisplay: displayId)
            },
            onRequestAccessibility: { [authorization] in authorization.requestTrust() },
            onOpenStart: { [weak self] in self?.openStartMenu() },
            onOpenSettings: { [weak self] in self?.openSettings() },
            onOpenAbout: { [weak self] in self?.openAbout() },
            onTogglePin: { [weak self] entry in self?.togglePin(entry: entry) },
            onCloseWindow: { [weak self] entry in self?.closeWindow(entry: entry) },
            onQuit: { [weak self] entry in self?.quit(entry: entry) },
            onDropPin: { [weak self] dropped, target in
                self?.reorder(draggedKey: dropped, onto: target)
            },
            onToggleDesktop: { [weak self] in self?.toggleShowDesktop() },
            onMiddleClick: { [weak self] entry, displayId in
                self?.openNewInstance(entry: entry, onDisplay: displayId)
            },
            onOpenBattery: { [weak self] in self?.openBatteryPanel() },
            onOpenNotifications: { [menuExtras] in
                _ = menuExtras.press(BarControlMetrics.clockIdentifier)
            },
            onOpenControlCentre: { [weak self] in self?.openControlCentre() },
            onOpenDay: { [weak self] in self?.openDayPanel() },
            onOpenSessions: { [weak self] in self?.openSessionsPanel() },
            onRaiseWindow: { [weak self] windowId in self?.raise(windowId: windowId) },
            onCloseWindowId: { [weak self] windowId in self?.close(windowId: windowId) }
        )
        host.present(preset: preset)
        bar = host
    }

    package func raise(windowId: CGWindowID) {
        guard let window = registry.windows.first(where: { $0.identity.cgWindowId == windowId }) else {
            BarLog.bar.notice("raise window=\(windowId) refused=unknown")
            return
        }
        let elsewhere = !window.isMinimized && !WindowSpacePolicy.isOnActiveSpace(window)
        let shown = elsewhere ? spaces.showSpace(ofWindowId: windowId) : false
        let raised = control.perform(window.isMinimized ? .restore : .raise, on: window)
        BarLog.bar.notice("raise window=\(windowId) elsewhere=\(elsewhere) shown=\(shown) raised=\(raised)")
        requestRefresh()
    }

    package func close(windowId: CGWindowID) {
        guard let window = registry.windows.first(where: { $0.identity.cgWindowId == windowId }) else {
            return
        }
        _ = control.close(window)
        requestRefresh()
    }

    private let store: any PinnedAppStorePort
}
