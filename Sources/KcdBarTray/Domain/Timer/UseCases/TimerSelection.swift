import Foundation

/** Everything the channel reports as running, this project's timers first. */
package enum TimerSelection {
    package static func reading(from timers: [RunningTimer]?, projectId: Int) -> TimerReading {
        guard let timers else { return .unknown }
        guard !timers.isEmpty else { return .idle }

        return .running(ordered(timers, projectId: projectId))
    }

    package static func ordered(_ timers: [RunningTimer], projectId: Int) -> [RunningTimer] {
        timers.sorted { left, right in
            let leftIsOurs = left.projectId == projectId
            let rightIsOurs = right.projectId == projectId
            guard leftIsOurs == rightIsOurs else { return leftIsOurs }

            return left.startedAt < right.startedAt
        }
    }
}
