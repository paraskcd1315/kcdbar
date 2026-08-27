import CoreGraphics
import Testing
@testable import KcdBarTaskbar

struct TaskbarRimPlacementTests {
    private let measured = CGRect(x: 0, y: 40, width: 1920, height: 62)

    @Test func anAttachedBarWearsTheRimOnItsWholeFrame() {
        let rect = TaskbarRimPlacement.rect(measured: measured, attachment: .edgeAttached)

        #expect(rect == measured)
    }

    @Test func aFloatingBarWearsTheRimInsideItsOutset() {
        let rect = TaskbarRimPlacement.rect(measured: measured, attachment: .floating)

        #expect(rect == measured.insetBy(dx: TaskbarMetrics.islandOutset, dy: TaskbarMetrics.islandOutset))
    }

    @Test func aBarNotYetMeasuredHasNoRim() {
        #expect(TaskbarRimPlacement.rect(measured: nil, attachment: .edgeAttached) == nil)
        #expect(TaskbarRimPlacement.rect(measured: .zero, attachment: .edgeAttached) == nil)
    }
}
