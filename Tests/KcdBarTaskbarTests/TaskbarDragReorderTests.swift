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

struct TaskbarDragReorderTests {
    private func entry(id: String, bundle: String?, pinned: Bool = false) -> TaskbarEntryModel {
        TaskbarEntryModel(
            id: id,
            title: id,
            applicationName: bundle ?? "",
            bundleIdentifier: bundle,
            icon: nil,
            isMinimized: false,
            isFrontmost: false,
            isPinned: pinned,
            isLauncher: false,

            isRunning: true,
            instanceCount: 1,
            instancesOnThisDisplay: 1,
            previewWindows: []
        )
    }

    @Test func draggingRightPushesTheHoveredEntryLeft() {
        let entries = [entry(id: "a", bundle: nil), entry(id: "b", bundle: nil), entry(id: "c", bundle: nil)]

        let previewed = TaskbarDragReorder.preview(entries: entries, dragging: "a", over: "c")

        #expect(previewed.map(\.id) == ["b", "c", "a"])
    }

    @Test func draggingLeftPushesTheHoveredEntryRight() {
        let entries = [entry(id: "a", bundle: nil), entry(id: "b", bundle: nil), entry(id: "c", bundle: nil)]

        let previewed = TaskbarDragReorder.preview(entries: entries, dragging: "c", over: "a")

        #expect(previewed.map(\.id) == ["c", "a", "b"])
    }

    @Test func hoveringTheDraggedEntryLeavesTheOrderAlone() {
        let entries = [entry(id: "a", bundle: nil), entry(id: "b", bundle: nil)]

        let previewed = TaskbarDragReorder.preview(entries: entries, dragging: "a", over: "a")

        #expect(previewed.map(\.id) == ["a", "b"])
    }

    @Test func noTargetLeavesTheOrderAlone() {
        let entries = [entry(id: "a", bundle: nil), entry(id: "b", bundle: nil)]

        #expect(TaskbarDragReorder.preview(entries: entries, dragging: "a", over: nil).map(\.id) == ["a", "b"])
        #expect(TaskbarDragReorder.preview(entries: entries, dragging: nil, over: "b").map(\.id) == ["a", "b"])
    }

    @Test func everyWindowOfOnePinnedApplicationMovesTogether() {
        let entries = [
            entry(id: "cg:10", bundle: "com.example.app", pinned: true),
            entry(id: "cg:11", bundle: "com.example.app", pinned: true),
            entry(id: "cg:20", bundle: nil)
        ]

        let previewed = TaskbarDragReorder.preview(
            entries: entries,
            dragging: "app:com.example.app",
            over: "cg:20"
        )

        #expect(previewed.map(\.id) == ["cg:20", "cg:10", "cg:11"])
    }

    @Test func previewIsIdempotentSoHoveringTwiceCannotOscillate() {
        let entries = [entry(id: "a", bundle: nil), entry(id: "b", bundle: nil), entry(id: "c", bundle: nil)]

        let once = TaskbarDragReorder.preview(entries: entries, dragging: "a", over: "c")
        let twice = TaskbarDragReorder.preview(entries: entries, dragging: "a", over: "c")

        #expect(once.map(\.id) == twice.map(\.id))
    }
}
