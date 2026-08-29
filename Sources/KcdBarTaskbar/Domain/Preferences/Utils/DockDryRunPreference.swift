import Foundation

package enum DockDryRunPreference {
    package static let key = "KCDBarDockDryRun"

    package static var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: key)
    }
}
