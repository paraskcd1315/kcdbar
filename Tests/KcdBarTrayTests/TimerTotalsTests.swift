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
