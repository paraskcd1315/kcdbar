/** Picks this project's timer out of every timer the channel carries. */
package enum TimerSelection {
    package static func reading(from timers: [RunningTimer]?, projectId: Int) -> TimerReading {
        guard let timers else { return .unknown }
        guard let mine = timers.first(where: { $0.projectId == projectId }) else { return .idle }

        return .running(mine)
    }
}
