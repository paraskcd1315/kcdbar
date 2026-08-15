import Foundation

/** The composition root, and the only place naming a concrete platform implementation. */
@MainActor
final class AppServices {
    let icons: any ApplicationIconPort = WorkspaceIconSource()
    let displays: any DisplayGeometryPort = ScreenGeometrySource()
    let authorization: any AccessibilityAuthorizationPort = AccessibilityAuthorization()
    let changes: any WindowChangeObserverPort = WorkspaceWindowChangeObserver()
    let registry: WindowRegistry

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
    }

    func startBar(preset: BarPreset, onActivate: @escaping (TaskbarEntryModel) -> Void) {
        activePreset = preset
        let host = BarPanelHost(
            registry: registry,
            icons: icons,
            displaySource: displays,
            onActivate: onActivate,
            onRequestAccessibility: { [authorization] in authorization.requestTrust() }
        )
        host.present(preset: preset)
        bar = host
    }
}
