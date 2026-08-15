@MainActor
package protocol TimerSignalPort {
    func listen(
        _ onChange: @escaping @MainActor @Sendable (TimerReading) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    )
    func stop()
}
