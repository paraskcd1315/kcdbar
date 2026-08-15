import CoreGraphics
import Testing
@testable import KcdBarTray

struct PopoverAnchorTests {
    private let screen = CGRect(x: 0, y: 0, width: 1920, height: 1080)
    private let size = CGSize(width: 340, height: 200)

    @Test func aPopoverCentresOnItsAnchor() {
        let origin = PopoverAnchor.origin(for: size, anchor: CGPoint(x: 960, y: 40), within: screen)

        #expect(origin.x == 790)
    }

    @Test func aPopoverNearTheLeftEdgeStopsAtIt() {
        let origin = PopoverAnchor.origin(for: size, anchor: CGPoint(x: 20, y: 40), within: screen)

        #expect(origin.x == 0)
    }

    @Test func aPopoverNearTheRightEdgeStopsAtIt() {
        let origin = PopoverAnchor.origin(for: size, anchor: CGPoint(x: 1900, y: 40), within: screen)

        #expect(origin.x == 1580)
    }

    @Test func aPopoverSitsAboveItsAnchor() {
        let origin = PopoverAnchor.origin(for: size, anchor: CGPoint(x: 960, y: 40), within: screen)

        #expect(origin.y > 40)
    }

    @Test func aTallPopoverIsHeldInsideTheTopEdge() {
        let tall = CGSize(width: 340, height: 1200)
        let origin = PopoverAnchor.origin(for: tall, anchor: CGPoint(x: 960, y: 40), within: screen)

        #expect(origin.y == 0)
    }
}
