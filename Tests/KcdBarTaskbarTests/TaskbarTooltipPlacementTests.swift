import CoreGraphics
import Testing

@testable import KcdBarTaskbar

struct TaskbarTooltipPlacementTests {
    private let panel = CGSize(width: 1440, height: 92)
    private let tooltip = CGSize(width: 300, height: 40)

    @Test func aTooltipOverAnEntryAtTheLeftEdgeStaysOnTheDisplay() {
        let entry = CGRect(x: 4, y: 44, width: 40, height: 40)

        let x = TaskbarTooltipPlacement.x(over: entry, tooltip: tooltip, panel: panel, edge: .bottom)

        #expect(x - tooltip.width / 2 >= 0)
    }

    @Test func aTooltipOverAnEntryAtTheRightEdgeStaysOnTheDisplay() {
        let entry = CGRect(x: 1400, y: 44, width: 40, height: 40)

        let x = TaskbarTooltipPlacement.x(over: entry, tooltip: tooltip, panel: panel, edge: .bottom)

        #expect(x + tooltip.width / 2 <= panel.width)
    }

    @Test func aTooltipWithRoomOnBothSidesIsCentredOnItsEntry() {
        let entry = CGRect(x: 700, y: 44, width: 40, height: 40)

        let x = TaskbarTooltipPlacement.x(over: entry, tooltip: tooltip, panel: panel, edge: .bottom)

        #expect(x == entry.midX)
    }

    @Test func aBottomBarPutsItsTooltipAboveTheEntry() {
        let entry = CGRect(x: 700, y: 44, width: 40, height: 40)

        let y = TaskbarTooltipPlacement.y(over: entry, tooltip: tooltip, panel: panel, edge: .bottom)

        #expect(y + tooltip.height / 2 <= entry.minY)
    }

    @Test func aTopBarPutsItsTooltipBelowTheEntry() {
        let entry = CGRect(x: 700, y: 8, width: 40, height: 40)

        let y = TaskbarTooltipPlacement.y(over: entry, tooltip: tooltip, panel: panel, edge: .top)

        #expect(y - tooltip.height / 2 >= entry.maxY)
    }

    @Test func aVerticalBarPutsItsTooltipBesideTheEntryAndKeepsItOnTheDisplay() {
        let tall = CGSize(width: 92, height: 900)
        let entry = CGRect(x: 8, y: 870, width: 40, height: 40)

        let x = TaskbarTooltipPlacement.x(over: entry, tooltip: tooltip, panel: tall, edge: .leading)
        let y = TaskbarTooltipPlacement.y(over: entry, tooltip: tooltip, panel: tall, edge: .leading)

        #expect(x - tooltip.width / 2 >= entry.maxX)
        #expect(y + tooltip.height / 2 <= tall.height)
    }
}
