@MainActor
package protocol SessionsSignalPort {
    func listen(
        _ onChange: @escaping @MainActor @Sendable ([ClaudeSession]) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    )
    func stop()
}
