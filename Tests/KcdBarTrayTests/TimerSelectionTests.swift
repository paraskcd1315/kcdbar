import Foundation
import Testing

@testable import KcdBarTray

struct TimerSelectionTests {
    private func timer(projectId: Int?, startedAt: TimeInterval = 0) -> RunningTimer {
        RunningTimer(
            projectId: projectId,
            jiraKey: "KCDBAR-37",
            detail: "a timer",
            startedAt: Date(timeIntervalSince1970: startedAt),
            isBillable: true,
            source: "kimai"
        )
    }

    @Test func noSnapshotAtAllIsUnknown() {
        #expect(TimerSelection.reading(from: nil, projectId: 13) == .unknown)
    }

    @Test func aSnapshotWithNoTimersIsIdleRatherThanUnknown() {
        #expect(TimerSelection.reading(from: [], projectId: 13) == .idle)
    }

    @Test func everyRunningTimerIsCarried() {
        let reading = TimerSelection.reading(
            from: [timer(projectId: 1), timer(projectId: 13)],
            projectId: 13
        )

        #expect(reading.timers.count == 2)
    }

    @Test func thisProjectsTimerComesFirst() {
        let mine = timer(projectId: 13, startedAt: 500)
        let theirs = timer(projectId: 1, startedAt: 100)
        let reading = TimerSelection.reading(from: [theirs, mine], projectId: 13)

        #expect(reading.timers.first == mine)
    }

    @Test func timersOfOneProjectKeepTheirStartingOrder() {
        let early = timer(projectId: 1, startedAt: 100)
        let late = timer(projectId: 1, startedAt: 900)
        let reading = TimerSelection.reading(from: [late, early], projectId: 13)

        #expect(reading.timers == [early, late])
    }

    @Test func oneTimerAloneIsTheOnlyOne() {
        let reading = TimerSelection.reading(from: [timer(projectId: 13)], projectId: 13)

        #expect(reading.only == timer(projectId: 13))
    }

    @Test func severalTimersHaveNoSingleOne() {
        let reading = TimerSelection.reading(
            from: [timer(projectId: 13), timer(projectId: 1)],
            projectId: 13
        )

        #expect(reading.only == nil)
    }
}
