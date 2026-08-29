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

import CoreGraphics
import Testing

@testable import KcdBarTaskbar

struct WindowIdentityTests {
    @Test func aWindowThatMovedIsTheSameWindow() {
        let before = WindowIdentity(ownerPid: 1, cgWindowId: 7, fallbackKey: "1:0:0")
        let after = WindowIdentity(ownerPid: 1, cgWindowId: 7, fallbackKey: "1:640:480")

        #expect(before == after)
        #expect(before.hashValue == after.hashValue)
    }

    @Test func twoWindowIdsAreTwoWindowsWhateverTheirFallbackKeys() {
        let first = WindowIdentity(ownerPid: 1, cgWindowId: 7, fallbackKey: "1:0:0")
        let second = WindowIdentity(ownerPid: 1, cgWindowId: 8, fallbackKey: "1:0:0")

        #expect(first != second)
    }

    @Test func aWindowWithNoIdIsMatchedByItsFallbackKey() {
        let first = WindowIdentity(ownerPid: 1, cgWindowId: nil, fallbackKey: "1:ax0")
        let same = WindowIdentity(ownerPid: 1, cgWindowId: nil, fallbackKey: "1:ax0")
        let other = WindowIdentity(ownerPid: 1, cgWindowId: nil, fallbackKey: "1:ax1")

        #expect(first == same)
        #expect(first != other)
    }

    @Test func anIdentifiedWindowNeverMatchesAnUnidentifiedOne() {
        let identified = WindowIdentity(ownerPid: 1, cgWindowId: 7, fallbackKey: "1:ax0")
        let unidentified = WindowIdentity(ownerPid: 1, cgWindowId: nil, fallbackKey: "1:ax0")

        #expect(identified != unidentified)
    }

    @Test func twoApplicationsNeverShareAnIdentity() {
        let mine = WindowIdentity(ownerPid: 1, cgWindowId: 7, fallbackKey: "1:0:0")
        let theirs = WindowIdentity(ownerPid: 2, cgWindowId: 7, fallbackKey: "2:0:0")

        #expect(mine != theirs)
    }

    @Test func aMovedWindowKeepsItsConfirmationThroughAnOmittedPass() {
        let before = WindowFixtures.cgRecord(
            windowId: 50,
            pid: 30,
            title: "Moving",
            bounds: CGRect(x: 0, y: 0, width: 800, height: 600)
        )
        let confirmed = WindowReconciler.reconcile(
            coreGraphics: [before],
            accessibility: .answered([WindowFixtures.axRecord(pid: 30, cgWindowId: 50, title: "Moving")]),
            previous: []
        )

        let moved = WindowFixtures.cgRecord(
            windowId: 50,
            pid: 30,
            title: "Moving",
            bounds: CGRect(x: 640, y: 480, width: 800, height: 600)
        )
        let now = WindowReconciler.reconcile(
            coreGraphics: [moved],
            accessibility: AxWindowScan(records: [], answeredPids: [30], liveOmittedIds: [50]),
            previous: confirmed
        )

        #expect(now[0].source == .both)
        #expect(WindowPresentationPolicy.isTaskbarEntry(now[0]))
    }
}
