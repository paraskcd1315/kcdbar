import Foundation

/** Which menu bar items the tray hosts. */
enum MenuBarItemPolicy {
    static func isHostable(bundleIdentifier: String?) -> Bool {
        guard let bundleIdentifier, !bundleIdentifier.isEmpty else { return false }

        return !bundleIdentifier.hasPrefix(TrayMetrics.systemBundlePrefix)
    }

    static func hostable(_ items: [MenuBarItem]) -> [MenuBarItem] {
        items.filter { isHostable(bundleIdentifier: $0.bundleIdentifier) }
    }
}
