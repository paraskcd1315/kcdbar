import KcdBarTaskbar

/** Stands in when the store file cannot be opened, so the bar still runs. */
package actor EphemeralPinnedAppStore: PinnedAppStorePort, StartPinStorePort, StartGroupStorePort {
    package init() {}

    private var apps: [PinnedApp] = []
    private var startApps: [PinnedApp] = []

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

    package func startPins() async -> [PinnedApp] {
        startApps.sorted { $0.order < $1.order }
    }

    package func pinToStart(_ app: PinnedApp) async {
        startApps.removeAll { $0.bundleIdentifier == app.bundleIdentifier }
        startApps.append(app)
    }

    package func unpinFromStart(bundleIdentifier: String) async {
        startApps.removeAll { $0.bundleIdentifier == bundleIdentifier }
    }

    package func reorderStartPins(_ apps: [PinnedApp]) async {
        startApps = apps
    }

    private var groups: [StartGroup] = []
    private var memberships: [StartGroupMembership] = []

    package func startGroups() async -> [StartGroup] {
        groups.sorted { $0.order < $1.order }
    }

    package func saveStartGroup(_ group: StartGroup) async {
        groups.removeAll { $0.id == group.id }
        groups.append(group)
    }

    package func deleteStartGroup(id: String) async {
        groups.removeAll { $0.id == id }
        memberships.removeAll { $0.groupId == id }
    }

    package func startGroupMemberships() async -> [StartGroupMembership] {
        memberships
    }

    package func saveStartGroupMembership(_ membership: StartGroupMembership) async {
        memberships.removeAll { $0.bundleIdentifier == membership.bundleIdentifier }
        memberships.append(membership)
    }

    package func clearStartGroupMembership(bundleIdentifier: String) async {
        memberships.removeAll { $0.bundleIdentifier == bundleIdentifier }
    }
}
