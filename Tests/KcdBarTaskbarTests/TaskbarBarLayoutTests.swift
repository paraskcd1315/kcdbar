import SwiftUI
import Testing

@testable import KcdBarTaskbar

struct TaskbarBarLayoutTests {
    @Test func aFloatingBarStaysAnchoredToItsOwnEdge() {
        var floating = BarPresetCatalogue.windows11
        floating.attachment = .floating

        #expect(TaskbarBarLayout.crossAxisVertical(preset: floating) == .bottom)
        #expect(TaskbarBarLayout.outsetPadding(attachment: floating.attachment) == TaskbarMetrics.islandOutset)
    }

    @Test func aFloatingTopBarAnchorsToTheTop() {
        var floating = BarPresetCatalogue.minimal
        floating.edge = .top
        floating.attachment = .floating

        #expect(TaskbarBarLayout.crossAxisVertical(preset: floating) == .top)
    }

    @Test func aFloatingVerticalBarAnchorsToItsSide() {
        var floating = BarPresetCatalogue.windows11
        floating.edge = .leading
        floating.attachment = .floating

        #expect(TaskbarBarLayout.crossAxisHorizontal(preset: floating) == .leading)

        floating.edge = .trailing

        #expect(TaskbarBarLayout.crossAxisHorizontal(preset: floating) == .trailing)
    }

    @Test func theFloatingFrameIsTheBarPlusItsOutsetOnBothSides() {
        var floating = BarPresetCatalogue.windows11
        floating.attachment = .floating
        let display = DisplayGeometry(
            id: 1,
            frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
            isPrimary: true
        )

        let frame = BarFrameCalculator.frame(for: floating, on: display)

        #expect(frame.height == floating.thickness + TaskbarMetrics.islandOutset * 2)
        #expect(frame.minY == 0)
    }
}
