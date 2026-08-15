/** An application pinned to the bar. */
struct PinnedApp: Codable, Equatable, Sendable, Identifiable {
    var bundleIdentifier: String
    var displayName: String
    var order: Int

    var id: String { bundleIdentifier }
}
