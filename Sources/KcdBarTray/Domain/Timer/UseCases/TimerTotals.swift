import Foundation

/** The time several timers have run between them. */
package enum TimerTotals {
    package static func elapsed(of timers: [RunningTimer], at moment: Date) -> TimeInterval {
        timers.reduce(0) { total, timer in
            total + max(moment.timeIntervalSince(timer.startedAt), 0)
        }
    }

    package static func earliest(of timers: [RunningTimer]) -> Date? {
        timers.map(\.startedAt).min()
    }
}
