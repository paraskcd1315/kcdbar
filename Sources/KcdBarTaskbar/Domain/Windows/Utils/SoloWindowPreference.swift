import Foundation

/** One window per display fights the user until it is gesture-driven, so it is off unless asked for. */
package enum SoloWindowPreference {
    package static let key = "KCDBarSoloWindows"

    package static var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: key)
    }

    package static func set(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: key)
    }
}
