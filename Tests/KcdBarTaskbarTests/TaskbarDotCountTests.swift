import Testing

@testable import KcdBarTaskbar

struct TaskbarDotCountTests {
    @Test func anApplicationThatIsNotRunningHasNoDots() {
        #expect(TaskbarDotCount.dots(windows: 0, isRunning: false) == 0)
    }

    @Test func aRunningApplicationWithNoWindowsKeepsItsProcessDot() {
        #expect(TaskbarDotCount.dots(windows: 0, isRunning: true) == 1)
    }

    @Test func theFirstDotIsTheProcessAndTheRestAreWindows() {
        #expect(TaskbarDotCount.dots(windows: 1, isRunning: true) == 2)
        #expect(TaskbarDotCount.dots(windows: 2, isRunning: true) == 3)
        #expect(TaskbarDotCount.dots(windows: 4, isRunning: true) == 5)
    }
}
