@MainActor
package protocol TotalsSignalPort {
    func listen(
        _ onChange: @escaping @MainActor @Sendable (TrackerTotals) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    )
    func stop()
}
