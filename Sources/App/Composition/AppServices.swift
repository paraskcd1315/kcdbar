import Foundation

/** The composition root, and the only place naming a concrete platform implementation. */
@MainActor
final class AppServices {
    let icons: any ApplicationIconPort = WorkspaceIconSource()
    let displays: any DisplayGeometryPort = ScreenGeometrySource()
    let authorization: any AccessibilityAuthorizationPort = AccessibilityAuthorization()
    let changes: any WindowChangeObserverPort = WorkspaceWindowChangeObserver()
    let registry: WindowRegistry

    private(set) var bar: (any BarPanelHostPort)?

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
