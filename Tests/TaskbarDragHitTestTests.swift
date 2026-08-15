import CoreGraphics
import Testing

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
