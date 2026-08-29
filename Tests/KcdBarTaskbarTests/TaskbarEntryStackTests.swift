import Testing

@testable import KcdBarTaskbar

struct TaskbarEntryStackTests {
    private func entry(windows: Int) -> TaskbarEntryModel {
        TaskbarEntryModel(
            id: "app", title: "App", applicationName: "App", bundleIdentifier: "com.example.app",
            icon: nil, isMinimized: false, isFrontmost: false, isPinned: false, isLauncher: false,
            isRunning: true, instanceCount: windows, instancesOnThisDisplay: windows, previewWindows: [])
    }

    @Test func oneSheetPerExtraWindowUpToFour() {
        #expect(TaskbarEntryStyle.stackSheets(entry(windows: 1), grouping: .perApplication) == 0)
        #expect(TaskbarEntryStyle.stackSheets(entry(windows: 2), grouping: .perApplication) == 1)
        #expect(TaskbarEntryStyle.stackSheets(entry(windows: 5), grouping: .perApplication) == 4)
        #expect(TaskbarEntryStyle.stackSheets(entry(windows: 9), grouping: .perApplication) == 4)
    }

    @Test func perWindowGroupingStacksNothing() {
        #expect(TaskbarEntryStyle.stackSheets(entry(windows: 3), grouping: .perWindow) == 0)
    }
}
