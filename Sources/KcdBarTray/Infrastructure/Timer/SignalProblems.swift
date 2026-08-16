import KcdSignal

/** Turns the reader's failure into the domain's. */
package enum SignalProblems {
    package static func of(_ problem: SignalProblem) -> ChannelProblem? {
        switch problem {
        case .nothingPublished: nil
        case .unreadable: .unreadable
        case .unknownVersion(let version): .unknownVersion(version)
        case .malformed(let detail): .malformed(detail)
        }
    }
}
