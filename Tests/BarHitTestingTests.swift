import CoreGraphics
import Testing

struct BarHitTestingTests {
    private let panel = CGRect(x: 0, y: 0, width: 1920, height: 96)
    private let island = CGRect(x: 765, y: 44, width: 390, height: 52)

    @Test func theIslandIsFlippedIntoScreenCoordinates() {
        let screen = BarHitTesting.screenRect(ofView: island, inPanel: panel)

        #expect(screen == CGRect(x: 765, y: 0, width: 390, height: 52))
    }

    @Test func aPanelAwayFromTheOriginCarriesItsOffset() {
        let offset = CGRect(x: 1920, y: -180, width: 1920, height: 96)
        let screen = BarHitTesting.screenRect(ofView: island, inPanel: offset)

        #expect(screen == CGRect(x: 2685, y: -180, width: 390, height: 52))
    }

    @Test func aPointOnTheIslandDoesNotPassThrough() {
        #expect(!BarHitTesting.passesThrough(CGPoint(x: 900, y: 20), barRect: island, panelFrame: panel))
    }

    @Test func theMarginsPassThrough() {
        #expect(BarHitTesting.passesThrough(CGPoint(x: 120, y: 20), barRect: island, panelFrame: panel))
        #expect(BarHitTesting.passesThrough(CGPoint(x: 1800, y: 20), barRect: island, panelFrame: panel))
    }

    @Test func anUnmeasuredBarKeepsItsClicks() {
        #expect(!BarHitTesting.passesThrough(CGPoint(x: 120, y: 20), barRect: nil, panelFrame: panel))
    }
}
