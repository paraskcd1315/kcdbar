import CoreGraphics
import Testing

@testable import KcdBarTaskbar

@MainActor
struct TaskbarEntryFoldingTests {
    private func entry(
        _ id: String,
        bundle: String?,
        frontmost: Bool = false,
        minimized: Bool = false,
        launcher: Bool = false,
        windowIds: [CGWindowID] = []
    ) -> TaskbarEntryModel {
        TaskbarEntryModel(
            id: id,
            title: id,
            applicationName: bundle ?? "",
            bundleIdentifier: bundle,
            icon: nil,
            isMinimized: minimized,
            isFrontmost: frontmost,
            isPinned: false,
            isLauncher: launcher,
            isRunning: true,
            instanceCount: 2,
            instancesOnThisDisplay: 2,
            previewWindows: windowIds.map { TaskbarPreviewWindow(id: $0, size: CGSize(width: 800, height: 600)) }
        )
    }

    @Test func perWindowLeavesEveryEntryWhereItIs() {
        let entries = [entry("a1", bundle: "app"), entry("a2", bundle: "app")]

        #expect(TaskbarEntryFolding.folded(entries, grouping: .perWindow) == entries)
    }

    @Test func perApplicationKeepsOneEntryPerApplication() {
        let entries = [
            entry("a1", bundle: "app"),
            entry("b1", bundle: "other"),
            entry("a2", bundle: "app")
        ]

        let folded = TaskbarEntryFolding.folded(entries, grouping: .perApplication)

        #expect(folded.count == 2)
        #expect(folded.map(\.bundleIdentifier) == ["app", "other"])
    }

    @Test func theFrontmostWindowRepresentsItsApplication() {
        let entries = [
            entry("a1", bundle: "app"),
            entry("a2", bundle: "app", frontmost: true)
        ]

        let folded = TaskbarEntryFolding.folded(entries, grouping: .perApplication)

        #expect(folded.first?.id == "a2")
        #expect(folded.first?.isFrontmost == true)
    }

    @Test func aFoldedEntryReadsMinimizedOnlyWhenEveryWindowIs() {
        let some = [
            entry("a1", bundle: "app", minimized: true),
            entry("a2", bundle: "app")
        ]
        let all = [
            entry("a1", bundle: "app", minimized: true),
            entry("a2", bundle: "app", minimized: true)
        ]

        #expect(TaskbarEntryFolding.folded(some, grouping: .perApplication).first?.isMinimized == false)
        #expect(TaskbarEntryFolding.folded(all, grouping: .perApplication).first?.isMinimized == true)
    }

    @Test func anEntryWithNoBundleIdentifierIsNeverFoldedAway() {
        let entries = [entry("w1", bundle: nil), entry("w2", bundle: nil)]

        #expect(TaskbarEntryFolding.folded(entries, grouping: .perApplication).count == 2)
    }

    @Test func aFoldedEntryCarriesEveryWindowItsSiblingsCouldPreview() {
        let entries = [
            entry("a1", bundle: "app", frontmost: true, windowIds: [10]),
            entry("a2", bundle: "app", windowIds: [11])
        ]

        let folded = TaskbarEntryFolding.folded(entries, grouping: .perApplication)

        #expect(folded.first?.previewWindows.map(\.id) == [10, 11])
    }

    @Test func siblingsCarryingTheSameWindowsFoldToOneListOfThem() {
        let entries = [
            entry("a1", bundle: "app", frontmost: true, windowIds: [10, 11]),
            entry("a2", bundle: "app", windowIds: [10, 11])
        ]

        let folded = TaskbarEntryFolding.folded(entries, grouping: .perApplication)

        #expect(folded.first?.previewWindows.map(\.id) == [10, 11])
    }

    @Test func anUnfoldedEntryKeepsOnlyItsOwnWindow() {
        let entries = [
            entry("a1", bundle: "app", windowIds: [10]),
            entry("b1", bundle: "other", windowIds: [11])
        ]

        let folded = TaskbarEntryFolding.folded(entries, grouping: .perWindow)

        #expect(folded.map { $0.previewWindows.map(\.id) } == [[10], [11]])
    }
}
