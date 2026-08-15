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
    private lazy var overlap = WindowOverlapEnforcer(control: control)
    private var activePreset = BarPresetCatalogue.default

    private(set) var bar: (any BarPanelHostPort)?

    func refreshAndEnforce(now: Date = Date()) {
        registry.refresh()
        overlap.enforce(
            preset: activePreset,
            windows: registry.windows,
            displays: registry.displays,
            now: now
        )
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
