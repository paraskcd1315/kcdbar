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
