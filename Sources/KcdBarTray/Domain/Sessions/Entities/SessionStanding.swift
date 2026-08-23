/** What a session says it is doing, in the words the machine's own record uses. */
package enum SessionStanding: String, Sendable, Equatable, CaseIterable {
    case busy
    case shell
    case idle
    case waiting

    package static func of(_ named: String?) -> SessionStanding? {
        guard let named else { return nil }

        return SessionStanding(rawValue: named.trimmingCharacters(in: .whitespaces).lowercased())
    }

    package var isWorking: Bool { self == .busy || self == .shell }

    package var isBlocked: Bool { self == .waiting }
}
