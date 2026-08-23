/** How much of a session's context window is in use. */
package struct SessionContext: Equatable, Sendable {
    package static let tightShare = 0.75
    package static let criticalShare = 0.90

    package let tokens: Int
    package let limit: Int

    package init(tokens: Int, limit: Int) {
        self.tokens = tokens
        self.limit = limit
    }

    package var share: Double { limit > 0 ? Double(tokens) / Double(limit) : 0 }

    package var isTight: Bool { share >= Self.tightShare }

    package var isCritical: Bool { share >= Self.criticalShare }
}
