import CoreGraphics
import Testing

@testable import KcdBarTaskbar

@MainActor
struct TaskbarHoverStateTests {
    private let entry = TaskbarEntryModel(
        id: "w1", title: "Doc", applicationName: "Editor", bundleIdentifier: "com.example.editor",
        icon: nil, isMinimized: false, isFrontmost: false, isPinned: false, isLauncher: false,
        isRunning: true, instanceCount: 1, instancesOnThisDisplay: 1, previewWindows: [])
    private let frame = CGRect(x: 10, y: 0, width: 96, height: 52)

    private func settled() async {
        try? await Task.sleep(for: .milliseconds(30))
    }

    @Test func leavingTheEntryClearsTheTooltipOnceTheLingerPasses() async {
        let hover = TaskbarHoverState(linger: .zero)
        hover.enter(entry, at: frame)

        hover.leave(entry)
        await settled()

        #expect(hover.entry == nil)
    }

    @Test func leavingTheEntryOntoTheTooltipKeepsIt() async {
        let hover = TaskbarHoverState(linger: .milliseconds(10))
        hover.enter(entry, at: frame)

        hover.leave(entry)
        hover.holdOverTooltip()
        await settled()

        #expect(hover.entry?.id == "w1")
    }

    @Test func leavingTheTooltipClearsItOnceTheLingerPasses() async {
        let hover = TaskbarHoverState(linger: .zero)
        hover.enter(entry, at: frame)
        hover.holdOverTooltip()

        hover.releaseTooltip()
        await settled()

        #expect(hover.entry == nil)
    }

    @Test func comingBackToTheEntryBeforeTheLingerPassesKeepsIt() async {
        let hover = TaskbarHoverState(linger: .milliseconds(10))
        hover.enter(entry, at: frame)

        hover.leave(entry)
        hover.enter(entry, at: frame)
        await settled()

        #expect(hover.entry?.id == "w1")
        #expect(hover.isShowing(entry))
    }

    @Test func leavingAnEntryThatIsNotShowingChangesNothing() async {
        let hover = TaskbarHoverState(linger: .zero)
        let other = TaskbarEntryModel(
            id: "w2", title: "Other", applicationName: "Other", bundleIdentifier: nil,
            icon: nil, isMinimized: false, isFrontmost: false, isPinned: false, isLauncher: false,
            isRunning: true, instanceCount: 1, instancesOnThisDisplay: 1, previewWindows: [])
        hover.enter(entry, at: frame)

        hover.leave(other)
        await settled()

        #expect(hover.entry?.id == "w1")
    }
}
