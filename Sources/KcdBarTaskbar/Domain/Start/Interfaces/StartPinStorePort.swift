package protocol StartPinStorePort: Sendable {
    func startPins() async -> [PinnedApp]
    func pinToStart(_ app: PinnedApp) async
    func unpinFromStart(bundleIdentifier: String) async
    func reorderStartPins(_ apps: [PinnedApp]) async
}
