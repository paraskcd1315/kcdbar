import Foundation

package enum TimerFormatting {
    package static func duration(_ seconds: TimeInterval) -> String {
        let total = max(Int(seconds), 0)
        let hours = total / TimerReadoutMetrics.secondsInHour
        let minutes =
            (total / TimerReadoutMetrics.secondsInMinute) % TimerReadoutMetrics.secondsInMinute
        let remainder = total % TimerReadoutMetrics.secondsInMinute

        guard hours > 0 else { return String(format: "%d:%02d", minutes, remainder) }

        return String(format: "%d:%02d:%02d", hours, minutes, remainder)
    }

    package static func elapsed(since started: Date, at moment: Date) -> String {
        duration(moment.timeIntervalSince(started))
    }

    package static func label(for timer: RunningTimer) -> String {
        timer.jiraKey ?? timer.detail
    }
}
