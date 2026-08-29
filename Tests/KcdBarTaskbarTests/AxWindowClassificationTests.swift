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

import Testing
@testable import KcdBarTaskbar

struct AxWindowClassificationTests {
    @Test func aStandardWindowIsSwitchable() {
        let record = WindowFixtures.axRecord(pid: 1, cgWindowId: 10, title: "Document")

        #expect(AxWindowClassification.isSwitchable(record))
    }

    @Test func aDialogIsSwitchable() {
        let record = WindowFixtures.axRecord(pid: 1, cgWindowId: 10, title: "Save", subrole: "AXDialog")

        #expect(AxWindowClassification.isSwitchable(record))
    }

    @Test func anUnknownSubroleIsNotSwitchable() {
        let popup = WindowFixtures.axRecord(pid: 1, cgWindowId: 10, title: nil, subrole: "AXUnknown")

        #expect(AxWindowClassification.isSwitchable(popup) == false)
    }

    @Test func aFloatingPanelIsNotSwitchable() {
        let panel = WindowFixtures.axRecord(pid: 1, cgWindowId: 10, title: "Tools", subrole: "AXFloatingWindow")

        #expect(AxWindowClassification.isSwitchable(panel) == false)
    }

    @Test func aMissingSubroleIsNotSwitchable() {
        let record = WindowFixtures.axRecord(pid: 1, cgWindowId: 10, title: "Odd", subrole: nil)

        #expect(AxWindowClassification.isSwitchable(record) == false)
    }

    @Test func chromesOmniboxPopupNeverBecomesATaskbarEntry() {
        let real = WindowFixtures.cgRecord(windowId: 6298, pid: 1, title: "YouTube")
        let popup = WindowFixtures.cgRecord(windowId: 6300, pid: 1, title: nil)
        let accessibility = [
            WindowFixtures.axRecord(pid: 1, cgWindowId: 6298, title: "YouTube"),
            WindowFixtures.axRecord(pid: 1, cgWindowId: 6300, title: nil, subrole: "AXUnknown")
        ]

        let reconciled = WindowReconciler.reconcile(
            coreGraphics: [real, popup],
            accessibility: .answered(accessibility),
            previous: []
        )
        let entries = WindowPresentationPolicy.taskbarEntries(from: reconciled)

        #expect(entries.map(\.identity.cgWindowId) == [6298])
    }
}
