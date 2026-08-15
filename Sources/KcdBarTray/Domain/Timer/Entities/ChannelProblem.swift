package enum ChannelProblem: Equatable, Sendable {
    case unreadable
    case unknownVersion(Int)
    case malformed(String)
}
