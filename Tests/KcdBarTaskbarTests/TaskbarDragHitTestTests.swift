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

struct TaskbarDragHitTestTests {
    private let slots = [
        "a": CGRect(x: 0, y: 0, width: 100, height: 52),
        "b": CGRect(x: 110, y: 0, width: 100, height: 52),
        "c": CGRect(x: 220, y: 0, width: 100, height: 52)
    ]

    @Test func pointerOverAnEntryReportsThatEntry() {
        let key = TaskbarDragHitTest.key(at: CGPoint(x: 150, y: 26), in: slots, dragging: "a")

        #expect(key == "b")
    }

    @Test func theDraggedEntrysOwnSlotIsNeverTheTarget() {
        let key = TaskbarDragHitTest.key(at: CGPoint(x: 50, y: 26), in: slots, dragging: "a")

        #expect(key == nil)
    }

    @Test func pointerInAGapBetweenEntriesReportsNothing() {
        let key = TaskbarDragHitTest.key(at: CGPoint(x: 105, y: 26), in: slots, dragging: "a")

        #expect(key == nil)
    }

    @Test func pointerOutsideTheStripReportsNothing() {
        let key = TaskbarDragHitTest.key(at: CGPoint(x: 900, y: 26), in: slots, dragging: "a")

        #expect(key == nil)
    }

    @Test func draggingRightThenLeftTracksTheEntryUnderThePointer() {
        #expect(TaskbarDragHitTest.key(at: CGPoint(x: 260, y: 26), in: slots, dragging: "a") == "c")
        #expect(TaskbarDragHitTest.key(at: CGPoint(x: 150, y: 26), in: slots, dragging: "c") == "b")
    }
}
