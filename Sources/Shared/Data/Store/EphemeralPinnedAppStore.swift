/** Stands in when the store file cannot be opened, so the bar still runs. */
actor EphemeralPinnedAppStore: PinnedAppStorePort {
    private var apps: [PinnedApp] = []

    func pinnedApps() async -> [PinnedApp] {
        apps.sorted { $0.order < $1.order }
    }

    func pin(_ app: PinnedApp) async {
        apps.removeAll { $0.bundleIdentifier == app.bundleIdentifier }
        apps.append(app)
    }

    func unpin(bundleIdentifier: String) async {
        apps.removeAll { $0.bundleIdentifier == bundleIdentifier }
    }

    func reorder(_ apps: [PinnedApp]) async {
        self.apps = apps
    }
}
