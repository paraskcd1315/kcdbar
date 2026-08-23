@MainActor
package protocol DaySignalPort {
    func listen(
        _ onChange: @escaping @MainActor @Sendable (TrackerDay) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    )
    func stop()
}
