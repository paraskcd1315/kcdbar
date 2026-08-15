import Testing

@testable import KcdBarBar

struct TaskbarDotCountTests {
    @Test func anApplicationThatIsNotRunningHasNoDots() {
        #expect(TaskbarDotCount.dots(windows: 0) == 0)
    }

    @Test func theFirstDotIsTheProcessAndTheRestAreWindows() {
        #expect(TaskbarDotCount.dots(windows: 1) == 2)
        #expect(TaskbarDotCount.dots(windows: 2) == 3)
        #expect(TaskbarDotCount.dots(windows: 4) == 5)
    }
}
