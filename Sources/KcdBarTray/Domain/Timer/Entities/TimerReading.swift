/** What the timer channel says about this project. */
package enum TimerReading: Equatable, Sendable {
    case unknown
    case idle
    case running(RunningTimer)

    package var timer: RunningTimer? {
        guard case let .running(timer) = self else { return nil }

        return timer
    }
}
