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

    func move(bundleIdentifier: String, before target: String?) async {
        var ordered = apps.sorted { $0.order < $1.order }
        guard let moving = ordered.first(where: { $0.bundleIdentifier == bundleIdentifier }) else {
            return
        }
        ordered.removeAll { $0.bundleIdentifier == bundleIdentifier }

        let insertion = target
            .flatMap { identifier in ordered.firstIndex { $0.bundleIdentifier == identifier } }
            ?? ordered.count
        ordered.insert(moving, at: insertion)

        apps = ordered.enumerated().map { index, app in
            PinnedApp(
                bundleIdentifier: app.bundleIdentifier,
                displayName: app.displayName,
                order: index
            )
        }
    }
}
