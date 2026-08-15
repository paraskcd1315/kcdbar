/** What the timer channel says is running. */
package enum TimerReading: Equatable, Sendable {
    case unknown
    case idle
    case running([RunningTimer])

    package var timers: [RunningTimer] {
        guard case let .running(timers) = self else { return [] }

        return timers
    }

    package var only: RunningTimer? {
        let running = timers

        return running.count == 1 ? running.first : nil
    }
}
