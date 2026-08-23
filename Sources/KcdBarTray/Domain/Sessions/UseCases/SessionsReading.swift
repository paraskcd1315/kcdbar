/** What the bar says about every session at once, which is the value the rim is drawn from. */
package enum SessionsReading: Equatable, Sendable {
    case unknown
    case quiet
    case working
    case waiting

    package static func of(_ sessions: [ClaudeSession]?) -> SessionsReading {
        guard let sessions else { return .unknown }

        if sessions.contains(where: \.isBlocked) { return .waiting }

        if sessions.contains(where: \.isWorking) { return .working }

        return .quiet
    }

    package var isWorking: Bool { self == .working || self == .waiting }

    package var wantsAttention: Bool { self == .waiting }
}
