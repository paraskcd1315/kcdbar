import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let services = AppServices()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        if !services.authorization.isTrusted {
            services.authorization.requestTrust()
        }

        services.startBar(preset: BarPresetCatalogue.default) { [services] entry in
            services.toggle(entryId: entry.id)
        }
        services.refreshAndEnforce()
        services.changes.startObserving { [services] in
            services.refreshAndEnforce()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        services.changes.stopObserving()
        services.bar?.dismiss()
    }
}
