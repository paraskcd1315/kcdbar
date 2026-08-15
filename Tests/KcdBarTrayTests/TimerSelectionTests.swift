import Foundation
import Testing

@testable import KcdBarTray

struct TimerSelectionTests {
    private func timer(projectId: Int?) -> RunningTimer {
        RunningTimer(
            projectId: projectId,
            jiraKey: "KCDBAR-37",
            detail: "a timer",
            startedAt: Date(timeIntervalSince1970: 0),
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

    @Test func anotherProjectsTimerLeavesThisOneIdle() {
        #expect(TimerSelection.reading(from: [timer(projectId: 1)], projectId: 13) == .idle)
    }

    @Test func ourOwnTimerIsFoundPastEveryOtherOne() {
        let mine = timer(projectId: 13)
        let reading = TimerSelection.reading(
            from: [timer(projectId: 1), mine, timer(projectId: 4)],
            projectId: 13
        )

        #expect(reading == .running(mine))
    }

    @Test func aTimerWithNoProjectIsNeverMistakenForOurs() {
        #expect(TimerSelection.reading(from: [timer(projectId: nil)], projectId: 13) == .idle)
    }
}
