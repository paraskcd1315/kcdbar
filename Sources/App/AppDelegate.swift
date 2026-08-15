import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let probe = GlassProbeController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        ScreenInsetProbe.report()
        probe.present()
    }
}
