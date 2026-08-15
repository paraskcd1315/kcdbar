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

    private(set) var bar: (any BarPanelHostPort)?

    func toggle(entryId: String) {
        guard let window = registry.window(withEntryId: entryId) else { return }
        let action = WindowToggleDecider.action(
            for: window,
            frontmostPid: registry.frontmostPid,
            among: registry.windows
        )
        _ = control.perform(action, on: window)
        registry.refresh()
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
