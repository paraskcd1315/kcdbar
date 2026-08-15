package protocol DockSnapshotStorePort: Sendable {
    func snapshot() async -> DockSettingsSnapshot?
    func remember(_ snapshot: DockSettingsSnapshot) async
    func clear() async
}
