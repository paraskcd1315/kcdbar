import AppKit
import KcdBarTaskbar

@MainActor
package final class AppDelegate: NSObject, NSApplicationDelegate {
    private let services = AppServices()

    package func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        if !services.authorization.isTrusted {
            services.authorization.requestTrust()
        }

        services.trash.start()
        services.timer.start()
        services.totals.start()
        Task { await services.start() }
        services.changes.startObserving { [services] in
            services.scheduleRefresh()
        }
    }

    package func applicationWillTerminate(_ notification: Notification) {
        services.stopObserving()
        services.timer.stop()
        services.totals.stop()
        services.bar?.dismiss()
    }
}
