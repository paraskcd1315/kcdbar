/** Every timer running at once, as the channel writes it. */
package struct TimerSignalPayload: Codable, Sendable, Equatable {
    package let timers: [TimerSignalEntry]

    package var runningTimers: [RunningTimer] {
        timers.filter(\.isRunning).map { $0.toEntity() }
    }
}
