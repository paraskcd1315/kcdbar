import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let probe = GlassProbeController()
    private let authorization = AccessibilityAuthorization()
    private lazy var registry = WindowRegistry(
        coreGraphicsSource: CoreGraphicsWindowSource(),
        accessibilitySource: AccessibilityWindowSource(),
        applicationsSource: WorkspaceApplicationsSource()
    )

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        probe.present()
        WindowRegistryProbe.report(registry: registry, authorization: authorization)
    }
}
