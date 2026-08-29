// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
