import Foundation

package enum TimerFormatting {
    package static func elapsed(since started: Date, at moment: Date) -> String {
        let total = max(Int(moment.timeIntervalSince(started)), 0)
        let hours = total / TimerReadoutMetrics.secondsInHour
        let minutes = (total / TimerReadoutMetrics.secondsInMinute) % TimerReadoutMetrics.secondsInMinute
        let seconds = total % TimerReadoutMetrics.secondsInMinute

        guard hours > 0 else { return String(format: "%d:%02d", minutes, seconds) }

        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }

    package static func label(for timer: RunningTimer) -> String {
        timer.jiraKey ?? timer.detail
    }
}
