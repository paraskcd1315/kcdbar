/** Which band a pinned application sits in, and where inside it. */
package struct StartGroupMembership: Equatable, Sendable, Identifiable {
    package var bundleIdentifier: String
    package var groupId: String
    package var order: Int

    package init(bundleIdentifier: String, groupId: String, order: Int) {
        self.bundleIdentifier = bundleIdentifier
        self.groupId = groupId
        self.order = order
    }

    package var id: String { bundleIdentifier }
}
