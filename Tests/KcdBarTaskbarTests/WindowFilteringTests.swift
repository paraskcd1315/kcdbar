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

struct WindowFilteringTests {
    @Test func ignoresWindowsOutsideTheNormalLayer() {
        let panel = WindowFixtures.cgRecord(windowId: 30, pid: 20, title: "Menu", layer: 25)

        #expect(WindowReconciler.isManageable(panel) == false)
    }

    @Test func ignoresWindowsTooSmallToBeRealOnes() {
        let tooSmall = CGRect(x: 0, y: 0, width: 12, height: 12)
        let tooltip = WindowFixtures.cgRecord(windowId: 31, pid: 21, title: nil, bounds: tooSmall)

        #expect(WindowReconciler.isManageable(tooltip) == false)
    }

    @Test func keepsOrdinaryApplicationWindows() {
        let window = WindowFixtures.cgRecord(windowId: 32, pid: 22, title: "Document")

        #expect(WindowReconciler.isManageable(window))
    }

    @Test func taskbarShowsOnlyWindowsAccessibilityConfirms() {
        let confirmed = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 33, pid: 23, title: "Real")],
            accessibility: .answered([WindowFixtures.axRecord(pid: 23, cgWindowId: 33, title: "Real")]),
            previous: []
        )
        let helperSurface = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 34, pid: 24, title: nil)],
            accessibility: .silent,
            previous: []
        )

        #expect(WindowPresentationPolicy.taskbarEntries(from: confirmed).count == 1)
        #expect(WindowPresentationPolicy.taskbarEntries(from: helperSurface).isEmpty)
    }

    @Test func minimizedWindowsRemainTaskbarEntries() {
        let minimized = WindowReconciler.reconcile(
            coreGraphics: [],
            accessibility: .answered([WindowFixtures.axRecord(pid: 25, cgWindowId: nil, title: "Away", isMinimized: true)]),
            previous: []
        )

        #expect(WindowPresentationPolicy.taskbarEntries(from: minimized).count == 1)
    }
}
