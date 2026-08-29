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

struct TaskbarEntryGroupingTests {
    private func entry(id: String, bundle: String?) -> TaskbarEntryModel {
        TaskbarEntryModel(
            id: id,
            title: id,
            applicationName: bundle ?? "",
            bundleIdentifier: bundle,
            icon: nil,
            isMinimized: false,
            isFrontmost: false,
            isPinned: false,
            isLauncher: false,

            isRunning: true,
            instanceCount: 1,
            instancesOnThisDisplay: 1,
            previewWindows: []
        )
    }

    @Test func windowsOfOneApplicationFormOneBandedGroup() {
        let entries = [
            entry(id: "cg:10", bundle: "com.example.app"),
            entry(id: "cg:11", bundle: "com.example.app")
        ]

        let groups = TaskbarEntryGrouping.groups(from: entries)

        #expect(groups.count == 1)
        #expect(groups[0].entries.count == 2)
        #expect(groups[0].isBanded)
    }

    @Test func aLoneWindowIsItsOwnUnbandedGroup() {
        let groups = TaskbarEntryGrouping.groups(from: [entry(id: "cg:10", bundle: "com.example.app")])

        #expect(groups.count == 1)
        #expect(groups[0].isBanded == false)
    }

    @Test func differentApplicationsNeverShareABand() {
        let entries = [
            entry(id: "cg:10", bundle: "com.example.one"),
            entry(id: "cg:11", bundle: "com.example.two")
        ]

        let groups = TaskbarEntryGrouping.groups(from: entries)

        #expect(groups.count == 2)
        #expect(groups.allSatisfy { !$0.isBanded })
    }

    @Test func windowsWithoutABundleIdentifierStaySeparate() {
        let entries = [entry(id: "cg:10", bundle: nil), entry(id: "cg:11", bundle: nil)]

        let groups = TaskbarEntryGrouping.groups(from: entries)

        #expect(groups.count == 2)
    }

    @Test func aBandOnlyFormsFromAdjacentEntries() {
        let entries = [
            entry(id: "cg:10", bundle: "com.example.one"),
            entry(id: "cg:11", bundle: "com.example.two"),
            entry(id: "cg:12", bundle: "com.example.one")
        ]

        let groups = TaskbarEntryGrouping.groups(from: entries)

        #expect(groups.count == 3)
    }

    @Test func orderingKeepsOneApplicationsWindowsAdjacent() {
        let entries = [
            entry(id: "cg:10", bundle: "com.example.one"),
            entry(id: "cg:11", bundle: "com.example.two"),
            entry(id: "cg:12", bundle: "com.example.one")
        ]
        let ranks = ["app:com.example.one": 0, "app:com.example.two": 1]

        let groups = TaskbarEntryGrouping.groups(
            from: TaskbarOrdering.ordered(entries: entries, ranks: ranks)
        )

        #expect(groups.map(\.id) == ["app:com.example.one", "app:com.example.two"])
        #expect(groups[0].isBanded)
    }
}
