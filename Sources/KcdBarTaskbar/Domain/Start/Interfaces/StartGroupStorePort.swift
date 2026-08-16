package protocol StartGroupStorePort: Sendable {
    func startGroups() async -> [StartGroup]
    func saveStartGroup(_ group: StartGroup) async
    func deleteStartGroup(id: String) async
    func startGroupMemberships() async -> [StartGroupMembership]
    func saveStartGroupMembership(_ membership: StartGroupMembership) async
    func clearStartGroupMembership(bundleIdentifier: String) async
}
