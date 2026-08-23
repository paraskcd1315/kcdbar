/** Every session running on this machine, as the channel writes them. */
package struct SessionsSignal: Codable, Sendable, Equatable {
    package let sessions: [SessionSignal]

    package func toEntity() -> [ClaudeSession] {
        sessions.map { $0.toEntity() }
    }
}
