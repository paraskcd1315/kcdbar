import Foundation
import Testing

@testable import KcdBarTray

struct TimerTotalsTests {
    private let now = Date(timeIntervalSince1970: 1000)

    private func timer(startedAt: TimeInterval) -> RunningTimer {
        RunningTimer(
            projectId: 13,
            jiraKey: nil,
            detail: "a timer",
            startedAt: Date(timeIntervalSince1970: startedAt),
            isBillable: false,
            source: "kimai"
        )
    }

    @Test func nothingRunningComesToNothing() {
        #expect(TimerTotals.elapsed(of: [], at: now) == 0)
        #expect(TimerTotals.earliest(of: []) == nil)
    }

    @Test func parallelTimersAddUp() {
        let total = TimerTotals.elapsed(of: [timer(startedAt: 400), timer(startedAt: 700)], at: now)

        #expect(total == 900)
    }

    @Test func aTimerStartedInTheFutureContributesNothingRatherThanNegative() {
        #expect(TimerTotals.elapsed(of: [timer(startedAt: 2000)], at: now) == 0)
    }

    @Test func theEarliestStartIsWhatATickerAnchorsOn() {
        let earliest = TimerTotals.earliest(of: [timer(startedAt: 700), timer(startedAt: 400)])

        #expect(earliest == Date(timeIntervalSince1970: 400))
    }
}
