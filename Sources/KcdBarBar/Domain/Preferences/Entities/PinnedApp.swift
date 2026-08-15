/** An application pinned to the bar. */
package struct PinnedApp: Codable, Equatable, Sendable, Identifiable {
    package var bundleIdentifier: String
    package var displayName: String
    package var order: Int

    package init(bundleIdentifier: String, displayName: String, order: Int) {
        self.bundleIdentifier = bundleIdentifier
        self.displayName = displayName
        self.order = order
    }

    package var id: String { bundleIdentifier }
}
