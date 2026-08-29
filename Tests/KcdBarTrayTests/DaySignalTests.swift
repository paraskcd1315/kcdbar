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

struct DaySignalTests {
    private let snapshot = """
        {"channel":"day.toggl","day":"2026-08-21T00:00:00Z","entries":[\
        {"contextPath":"UnimediaProjects/BetaniaPatmos","detail":"BP-31 Configurar sistema global",\
        "endedAt":"2026-08-21T09:47:00Z","id":401,"isBillable":true,"jiraKey":"BP-31",\
        "projectId":7,"startedAt":"2026-08-21T08:00:00Z"},\
        {"contextPath":"PersonalProjects/KCDBar","detail":"KCDBAR-97 the day in the popover",\
        "id":402,"isBillable":false,"jiraKey":"KCDBAR-97","projectId":13,\
        "startedAt":"2026-08-21T10:00:00Z"}],\
        "projects":[{"clientName":"Unimedia","colour":"#0B83D9","id":7,"name":"Betania Patmos"},\
        {"clientName":null,"colour":"#4BC800","id":13,"name":"KCDBar"}],\
        "publishedAt":"2026-08-21T10:15:00Z","v":1}
        """

    private func decoded(_ json: String) throws -> SignalEnvelope<DaySignal> {
        try SignalCoding.decoder.decode(SignalEnvelope<DaySignal>.self, from: Data(json.utf8))
    }

    private func stamp(_ text: String) -> Date? { ISO8601DateFormatter().date(from: text) }

    private var utc: Calendar {
        var made = Calendar(identifier: .gregorian)

        made.timeZone = TimeZone.gmt

        return made
    }

    @Test func thePayloadSitsBesideTheEnvelopeRatherThanUnderIt() throws {
        let envelope = try decoded(snapshot)

        #expect(envelope.channel == "day.toggl")
        #expect(envelope.payload.entries.count == 2)
        #expect(envelope.payload.projects.count == 2)
    }

    @Test func theDayCarriesItsOwnDateRatherThanTheMomentItWasPublished() throws {
        let day = try decoded(snapshot).payload.toEntity()

        #expect(day.day == stamp("2026-08-21T00:00:00Z"))
        #expect(day.day != stamp("2026-08-21T10:15:00Z"))
    }

    @Test func everyFieldABlockNeedsSurvivesTheDecode() throws {
        let entry = try #require(
            decoded(snapshot).payload.toEntity().entries.first { $0.id == 401 }
        )

        #expect(entry.detail == "BP-31 Configurar sistema global")
        #expect(entry.jiraKey == "BP-31")
        #expect(entry.contextPath == "UnimediaProjects/BetaniaPatmos")
        #expect(entry.projectId == 7)
        #expect(entry.isBillable)
        #expect(entry.startedAt == stamp("2026-08-21T08:00:00Z"))
        #expect(entry.endedAt == stamp("2026-08-21T09:47:00Z"))
        #expect(entry.isRunning == false)
    }

    @Test func anEntryWithNoEndIsTheOneStillRunning() throws {
        let entry = try #require(
            decoded(snapshot).payload.toEntity().entries.first { $0.id == 402 }
        )

        #expect(entry.endedAt == nil)
        #expect(entry.isRunning)
    }

    @Test func aRunningEntryEndsWhereeverTheClockSaysItIsNow() throws {
        let entry = try #require(
            decoded(snapshot).payload.toEntity().entries.first { $0.id == 402 }
        )
        let now = try #require(stamp("2026-08-21T10:30:00Z"))

        #expect(entry.endedAt(by: now) == now)
    }

    @Test func aFinishedEntryIgnoresTheClockAndKeepsItsOwnEnd() throws {
        let entry = try #require(
            decoded(snapshot).payload.toEntity().entries.first { $0.id == 401 }
        )
        let now = try #require(stamp("2026-08-21T18:00:00Z"))

        #expect(entry.endedAt(by: now) == stamp("2026-08-21T09:47:00Z"))
    }

    @Test func aProjectCarriesTheColourItsBlockIsDrawnIn() throws {
        let day = try decoded(snapshot).payload.toEntity()
        let entry = try #require(day.entries.first { $0.id == 401 })
        let project = try #require(day.project(of: entry))

        #expect(project.name == "Betania Patmos")
        #expect(project.clientName == "Unimedia")
        #expect(project.colour == "#0B83D9")
    }

    @Test func aProjectWithNoClientSaysSoRatherThanNamingOne() throws {
        let day = try decoded(snapshot).payload.toEntity()
        let entry = try #require(day.entries.first { $0.id == 402 })

        #expect(day.project(of: entry)?.clientName == nil)
    }

    @Test func anEntryBookedAgainstNoProjectFindsNoneRatherThanTheFirst() throws {
        let day = try decoded(snapshot).payload.toEntity()
        let loose = DayEntry(
            id: 999,
            detail: "loose",
            projectId: nil,
            jiraKey: nil,
            contextPath: nil,
            startedAt: Date(),
            endedAt: nil,
            isBillable: false)

        #expect(day.project(of: loose) == nil)
    }

    @Test func anEntryCarryingBothAKeyAndAPathIsTheOneThatCanOpen() throws {
        let day = try decoded(snapshot).payload.toEntity()

        let everyOneOpens = day.entries.allSatisfy(\.opensATicket)

        #expect(everyOneOpens)
    }

    @Test func anEntryMissingEitherHalfDoesNotClaimToOpen() throws {
        let noKey = """
            {"channel":"day.toggl","day":"2026-08-21T00:00:00Z","entries":[\
            {"contextPath":"PersonalProjects/KCDBar","detail":"reading","id":1,\
            "isBillable":false,"projectId":13,"startedAt":"2026-08-21T08:00:00Z"}],\
            "projects":[],"publishedAt":"2026-08-21T10:15:00Z","v":1}
            """

        let entry = try #require(decoded(noKey).payload.toEntity().entries.first)

        #expect(entry.jiraKey == nil)
        #expect(entry.opensATicket == false)
    }

    @Test func aDayWithNothingTrackedDecodesRatherThanFailing() throws {
        let empty = """
            {"channel":"day.toggl","day":"2026-08-21T00:00:00Z","entries":[],\
            "projects":[],"publishedAt":"2026-08-21T10:15:00Z","v":1}
            """

        let day = try decoded(empty).payload.toEntity()

        #expect(day.entries.isEmpty)
        #expect(day.day == stamp("2026-08-21T00:00:00Z"))
    }

    @Test func aVersionThisReaderDoesNotKnowIsRefused() {
        let future = """
            {"channel":"day.toggl","day":"2026-08-21T00:00:00Z","entries":[],\
            "projects":[],"publishedAt":"2026-08-21T10:15:00Z","v":2}
            """

        #expect(throws: (any Error).self) { try decoded(future) }
    }

    @Test func aSnapshotNobodyReplacedOvernightIsNotToday() throws {
        let day = try decoded(snapshot).payload.toEntity()
        let sameDay = try #require(stamp("2026-08-21T23:59:00Z"))
        let nextDay = try #require(stamp("2026-08-22T00:01:00Z"))

        #expect(day.covers(sameDay, in: utc))
        #expect(day.covers(nextDay, in: utc) == false)
    }
}
