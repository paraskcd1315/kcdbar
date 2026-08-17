import Foundation
import ServiceManagement

/** Registers the app to open at login. */
@MainActor
package enum LoginItem {
    private static let registeredKey = "kcdbar.loginItem.registered"

    package static func enableOnce(defaults: UserDefaults = .standard) {
        guard !defaults.bool(forKey: registeredKey) else { return }
        guard SMAppService.mainApp.status != .enabled else {
            defaults.set(true, forKey: registeredKey)

            return
        }

        do {
            try SMAppService.mainApp.register()

            defaults.set(true, forKey: registeredKey)
        } catch {
            return
        }
    }
}
