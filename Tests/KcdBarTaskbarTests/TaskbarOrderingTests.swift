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

struct TaskbarOrderingTests {
    private func entry(id: String, bundle: String?, pinned: Bool) -> TaskbarEntryModel {
        TaskbarEntryModel(
            id: id,
            title: id,
            applicationName: bundle ?? "",
            bundleIdentifier: bundle,
            icon: nil,
            isMinimized: false,
            isFrontmost: false,
            isPinned: pinned,
            isLauncher: false,

            isRunning: true,
            instanceCount: 1,
            instancesOnThisDisplay: 1,
            previewWindows: []
        )
    }

    @Test func windowsOfOnePinnedApplicationKeepTheirOrderAcrossRefreshes() {
        let first = entry(id: "cg:10", bundle: "com.example.app", pinned: true)
        let second = entry(id: "cg:11", bundle: "com.example.app", pinned: true)
        let ranks = ["app:com.example.app": 0, "cg:10": 1, "cg:11": 2]

        let forwards = TaskbarOrdering.ordered(entries: [first, second], ranks: ranks)
        let backwards = TaskbarOrdering.ordered(entries: [second, first], ranks: ranks)

        #expect(forwards.map(\.id) == ["cg:10", "cg:11"])
        #expect(backwards.map(\.id) == ["cg:10", "cg:11"])
    }

    @Test func pinnedApplicationsLeadInTheirPinnedOrder() {
        let pinned = entry(id: "cg:10", bundle: "com.example.pinned", pinned: true)
        let loose = entry(id: "cg:11", bundle: "com.example.other", pinned: false)
        let ranks = ["app:com.example.pinned": 0, "app:com.example.other": 1]

        let ordered = TaskbarOrdering.ordered(entries: [loose, pinned], ranks: ranks)

        #expect(ordered.map(\.id) == ["cg:10", "cg:11"])
    }

    @Test func unknownEntriesFallToTheEndDeterministically() {
        let known = entry(id: "cg:10", bundle: nil, pinned: false)
        let unknownA = entry(id: "cg:98", bundle: nil, pinned: false)
        let unknownB = entry(id: "cg:99", bundle: nil, pinned: false)

        let ordered = TaskbarOrdering.ordered(
            entries: [unknownB, unknownA, known],
            ranks: ["cg:10": 0]
        )

        #expect(ordered.map(\.id) == ["cg:10", "cg:98", "cg:99"])
    }

    @Test func everyWindowOfOneApplicationSharesAnOrderingSlot() {
        let first = TaskbarOrdering.orderingKey(bundleIdentifier: "com.example.app", entryId: "cg:10")
        let second = TaskbarOrdering.orderingKey(bundleIdentifier: "com.example.app", entryId: "cg:11")

        #expect(first == "app:com.example.app")
        #expect(first == second)
    }

    @Test func aWindowWithoutABundleIdentifierKeepsItsOwnSlot() {
        let key = TaskbarOrdering.orderingKey(bundleIdentifier: nil, entryId: "cg:10")

        #expect(key == "cg:10")
    }
}
