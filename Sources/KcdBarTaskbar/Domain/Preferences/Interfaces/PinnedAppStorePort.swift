package protocol PinnedAppStorePort: Sendable {
    func pinnedApps() async -> [PinnedApp]
    func pin(_ app: PinnedApp) async
    func unpin(bundleIdentifier: String) async
    func reorder(_ apps: [PinnedApp]) async
}
