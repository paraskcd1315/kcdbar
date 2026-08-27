package protocol QuitExclusionStorePort: Sendable {
    func quitExclusions() async -> [QuitExclusion]
    func exclude(_ exclusion: QuitExclusion) async
    func include(bundleIdentifier: String) async
}
