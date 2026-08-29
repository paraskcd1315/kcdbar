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
import KcdSignal
import Testing

@testable import KcdBarTray

struct TrackerPaceTests {
    private func pace(
        target: Int = 129_600,
        worked: Int = 74_940,
        today: Int = 8100,
        daysLeft: Int = 2,
        floor: Int = 21_600
    ) -> TrackerPace {
        TrackerPace(
            targetSeconds: target,
            workedSeconds: worked,
            workedTodaySeconds: today,
            daysLeft: daysLeft,
            minimumDaySeconds: floor
        )
    }

    @Test func whatTheWeekStillOwes() {
        #expect(pace().remainingSeconds == 54_660)
        #expect(!pace().isOver)
        #expect(pace().overSeconds == 0)
    }

    @Test func aWeekPastItsTargetOwesNothingAndReportsTheExcess() {
        let over = pace(worked: 140_000)

        #expect(over.isOver)
        #expect(over.remainingSeconds == 0)
        #expect(over.overSeconds == 10_400)
    }

    @Test func theDaySplitsWhatIsLeftButNeverBelowItsFloor() {
        #expect(pace().todaySeconds == 27_330)
        #expect(pace(worked: 125_000).todaySeconds == 4600)
    }

    @Test func aWeekWithNoDaysLeftAsksNothingOfToday() {
        #expect(pace(daysLeft: 0).todaySeconds == 0)
        #expect(pace(daysLeft: 0).leftTodaySeconds == 0)
    }

    @Test func whatTodayStillOwesNeverGoesNegative() {
        #expect(pace().leftTodaySeconds == 19_230)
        #expect(pace(today: 40_000).leftTodaySeconds == 0)
    }

    @Test func aDayThatStartedButStayedShortIsBelowTheFloor() {
        #expect(pace(today: 3600).isBelowFloor)
        #expect(!pace(today: 0).isBelowFloor)
        #expect(!pace(today: 22_000).isBelowFloor)
    }

    @Test func theFloorGivesWayOnceTheWeekOwesLessThanIt() {
        #expect(!pace(worked: 125_000, today: 5000).isBelowFloor)
        #expect(pace(worked: 125_000, today: 4000).isBelowFloor)
    }

    @Test func theLiveSnapshotDecodesWithNoPaceAtAll() throws {
        let json = """
            {"channel":"totals.kimai","publishedAt":"2026-08-15T21:38:08Z",\
            "todaySeconds":78578,"v":1,"weekSeconds":78578}
            """
        let envelope = try SignalCoding.decoder.decode(
            SignalEnvelope<TotalsSignal>.self,
            from: Data(json.utf8)
        )

        #expect(envelope.payload.toEntity().todaySeconds == 78578)
        #expect(envelope.payload.toEntity().weekSeconds == 78578)
        #expect(envelope.payload.toEntity().pace == nil)
    }

    @Test func aPaceThatIsSentSurvivesTheDecode() throws {
        let json = """
            {"channel":"totals.kimai","publishedAt":"2026-08-15T21:40:00Z",\
            "todaySeconds":8100,"weekSeconds":74940,"v":1,\
            "pace":{"targetSeconds":129600,"workedSeconds":74940,\
            "workedTodaySeconds":8100,"daysLeft":2,"minimumDaySeconds":21600}}
            """
        let decoded = try SignalCoding.decoder.decode(
            SignalEnvelope<TotalsSignal>.self,
            from: Data(json.utf8)
        )

        #expect(decoded.payload.toEntity().pace == pace())
    }
}
