import CoreGraphics
import Testing

@testable import KcdBarTaskbar

struct TaskbarEntryFullScreenTests {
    private func entry(fullScreen: [Bool]) -> TaskbarEntryModel {
        TaskbarEntryModel(
            id: "app", title: "App", applicationName: "App", bundleIdentifier: "com.example.app",
            icon: nil, isMinimized: false, isFrontmost: false, isPinned: false, isLauncher: false,
            isRunning: true, instanceCount: fullScreen.count, instancesOnThisDisplay: fullScreen.count,
            previewWindows: fullScreen.enumerated().map { index, flag in
                TaskbarPreviewWindow(id: CGWindowID(index + 1), size: CGSize(width: 800, height: 600), isFullScreen: flag)
            })
    }

    @Test func theCountIsTheFullScreenWindowsAmongThePreviews() {
        #expect(entry(fullScreen: [false, false]).fullScreenCount == 0)
        #expect(entry(fullScreen: [true, false]).fullScreenCount == 1)
        #expect(entry(fullScreen: [true, true, false]).fullScreenCount == 2)
    }

    @Test func anEntryIsFullScreenWhenAnyWindowIs() {
        #expect(entry(fullScreen: [false, true]).isFullScreen)
        #expect(!entry(fullScreen: [false]).isFullScreen)
    }
}
