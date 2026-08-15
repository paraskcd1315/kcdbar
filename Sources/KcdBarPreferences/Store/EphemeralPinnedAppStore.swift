import KcdBarBar

/** Stands in when the store file cannot be opened, so the bar still runs. */
package actor EphemeralPinnedAppStore: PinnedAppStorePort {
    package init() {}

    private var apps: [PinnedApp] = []

    package func pinnedApps() async -> [PinnedApp] {
        apps.sorted { $0.order < $1.order }
    }

    package func pin(_ app: PinnedApp) async {
        apps.removeAll { $0.bundleIdentifier == app.bundleIdentifier }
        apps.append(app)
    }

    package func unpin(bundleIdentifier: String) async {
        apps.removeAll { $0.bundleIdentifier == bundleIdentifier }
    }

    package func reorder(_ apps: [PinnedApp]) async {
        self.apps = apps
    }
}
