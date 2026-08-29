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

import CoreGraphics
import Testing

@testable import KcdBarTaskbar

@MainActor
struct TaskbarPreviewStateTests {
    private func windows(_ ids: [CGWindowID]) -> [TaskbarPreviewWindow] {
        ids.map { TaskbarPreviewWindow(id: $0, size: CGSize(width: 1200, height: 800)) }
    }

    @Test func restingOnAnEntryAsksForEveryWindowItHolds() async {
        let port = StubWindowPreviews()
        port.capturable = [10, 11]
        let state = TaskbarPreviewState(port: port)

        await state.load(windows([10, 11]))

        #expect(port.asked == [10, 11])
    }

    @Test func aWindowTheSystemWillNotCaptureLeavesNoThumbnail() async {
        let port = StubWindowPreviews()
        port.capturable = [10]
        let state = TaskbarPreviewState(port: port)

        await state.load(windows([10, 11]))

        #expect(state.previews[10] != nil)
        #expect(state.previews[11] == nil)
    }

    @Test func aMinimizedWindowIsStillAsked() async {
        let port = StubWindowPreviews()
        let state = TaskbarPreviewState(port: port)

        await state.load(windows([10]))

        #expect(port.asked == [10])
        #expect(state.previews.isEmpty)
    }

    @Test func aGroupedEntryAsksForAtMostTheThumbnailsItCanDraw() async {
        let port = StubWindowPreviews()
        let state = TaskbarPreviewState(port: port)

        await state.load(windows([10, 11, 12, 13, 14, 15]))

        #expect(port.asked.count == TaskbarPreviewMetrics.maximumThumbnails)
    }

    @Test func movingToAnotherEntryDropsTheThumbnailsOfTheOldOne() async {
        let port = StubWindowPreviews()
        port.capturable = [10, 11]
        let state = TaskbarPreviewState(port: port)

        await state.load(windows([10]))
        await state.load(windows([11]))

        #expect(state.previews[10] == nil)
        #expect(state.previews[11] != nil)
    }

    @Test func restingOnTheSameEntryTwiceDoesNotAskAgain() async {
        let port = StubWindowPreviews()
        port.capturable = [10]
        let state = TaskbarPreviewState(port: port)

        await state.load(windows([10]))
        await state.load(windows([10]))

        #expect(port.asked == [10])
    }

    @Test func leavingTheBarForgetsEveryThumbnail() async {
        let port = StubWindowPreviews()
        port.capturable = [10]
        let state = TaskbarPreviewState(port: port)
        await state.load(windows([10]))

        state.clear()

        #expect(state.previews.isEmpty)
    }

    @Test func anEntryWithNoWindowAsksForNothing() async {
        let port = StubWindowPreviews()
        let state = TaskbarPreviewState(port: port)

        await state.load(windows([]))

        #expect(port.asked.isEmpty)
    }
}
