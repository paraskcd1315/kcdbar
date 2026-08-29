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

struct SessionsReadingTests {
    private func session(_ id: String, _ standing: SessionStanding?) -> ClaudeSession {
        ClaudeSession(
            sessionId: id,
            title: id,
            standing: standing,
            waitingFor: nil,
            quietSince: nil,
            isTerminal: false,
            pane: nil,
            project: nil,
            doing: nil,
            outputTokens: nil,
            context: nil)
    }

    @Test func noChannelAtAllReadsAsUnknown() {
        #expect(SessionsReading.of(nil) == .unknown)
    }

    @Test func nothingRunningIsQuiet() {
        #expect(SessionsReading.of([]) == .quiet)
    }

    @Test func everySessionStoppedIsQuietRatherThanUnknown() {
        #expect(SessionsReading.of([session("a", .idle), session("b", .idle)]) == .quiet)
    }

    @Test func oneWorkingSessionIsWorking() {
        #expect(SessionsReading.of([session("a", .idle), session("b", .busy)]) == .working)
    }

    @Test func aShellCountsAsWorking() {
        #expect(SessionsReading.of([session("a", .shell)]) == .working)
    }

    @Test func oneWaitingSessionBeatsThreeWorkingOnes() {
        let four = [
            session("a", .busy), session("b", .busy), session("c", .busy), session("d", .waiting),
        ]

        #expect(SessionsReading.of(four) == .waiting)
    }

    @Test func waitingIsTheOnlyReadingThatWantsHim() {
        #expect(SessionsReading.waiting.wantsAttention)
        #expect(SessionsReading.working.wantsAttention == false)
        #expect(SessionsReading.quiet.wantsAttention == false)
        #expect(SessionsReading.unknown.wantsAttention == false)
    }

    @Test func waitingStillDrawsTheRimBecauseSomethingIsStillLive() {
        #expect(SessionsReading.waiting.isWorking)
        #expect(SessionsReading.working.isWorking)
        #expect(SessionsReading.quiet.isWorking == false)
        #expect(SessionsReading.unknown.isWorking == false)
    }

    @Test func aStandingNobodyStatedCountsAsNeitherWorkingNorWaiting() {
        #expect(SessionsReading.of([session("a", nil)]) == .quiet)
    }
}
