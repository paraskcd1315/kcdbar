import CoreGraphics
import Testing

@testable import KcdBarTaskbar

@MainActor
struct TaskbarPreviewStateTests {
    @Test func restingOnAnEntryAsksForEveryWindowItHolds() async {
        let port = StubWindowPreviews()
        port.capturable = [10, 11]
        let state = TaskbarPreviewState(port: port)

        await state.load([10, 11])

        #expect(port.asked == [10, 11])
    }

    @Test func aWindowTheSystemWillNotCaptureLeavesNoThumbnail() async {
        let port = StubWindowPreviews()
        port.capturable = [10]
        let state = TaskbarPreviewState(port: port)

        await state.load([10, 11])

        #expect(state.previews[10] != nil)
        #expect(state.previews[11] == nil)
    }

    @Test func aMinimizedWindowIsStillAsked() async {
        let port = StubWindowPreviews()
        let state = TaskbarPreviewState(port: port)

        await state.load([10])

        #expect(port.asked == [10])
        #expect(state.previews.isEmpty)
    }

    @Test func aGroupedEntryAsksForAtMostTheThumbnailsItCanDraw() async {
        let port = StubWindowPreviews()
        let state = TaskbarPreviewState(port: port)

        await state.load([10, 11, 12, 13, 14, 15])

        #expect(port.asked.count == TaskbarPreviewMetrics.maximumThumbnails)
    }

    @Test func movingToAnotherEntryDropsTheThumbnailsOfTheOldOne() async {
        let port = StubWindowPreviews()
        port.capturable = [10, 11]
        let state = TaskbarPreviewState(port: port)

        await state.load([10])
        await state.load([11])

        #expect(state.previews[10] == nil)
        #expect(state.previews[11] != nil)
    }

    @Test func restingOnTheSameEntryTwiceDoesNotAskAgain() async {
        let port = StubWindowPreviews()
        port.capturable = [10]
        let state = TaskbarPreviewState(port: port)

        await state.load([10])
        await state.load([10])

        #expect(port.asked == [10])
    }

    @Test func leavingTheBarForgetsEveryThumbnail() async {
        let port = StubWindowPreviews()
        port.capturable = [10]
        let state = TaskbarPreviewState(port: port)
        await state.load([10])

        state.clear()

        #expect(state.previews.isEmpty)
    }

    @Test func anEntryWithNoWindowAsksForNothing() async {
        let port = StubWindowPreviews()
        let state = TaskbarPreviewState(port: port)

        await state.load([])

        #expect(port.asked.isEmpty)
    }
}
