import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let services = AppServices()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        if !services.authorization.isTrusted {
            services.authorization.requestTrust()
        }

        services.registry.refresh()
        services.startBar(preset: BarPresetCatalogue.default) { _ in }
        services.changes.startObserving { [services] in
            services.registry.refresh()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        services.changes.stopObserving()
        services.bar?.dismiss()
    }
}
