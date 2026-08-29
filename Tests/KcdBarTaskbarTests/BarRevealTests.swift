import CoreGraphics
import Testing
@testable import KcdBarTaskbar

struct BarRevealTests {
    private let display = DisplayGeometry(
        id: 1,
        frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
        isPrimary: true
    )
    private let barFrame = CGRect(x: 400, y: 0, width: 1120, height: 52)
    private let previewFrame = CGRect(x: 800, y: 60, width: 360, height: 150)

    private func reveals(
        _ pointer: CGPoint, edge: BarEdge = .bottom, revealed: Bool = false, preview: CGRect? = nil
    ) -> Bool {
        BarRevealPolicy.shouldReveal(
            pointer: pointer, barFrame: barFrame, previewFrame: preview, display: display, edge: edge,
            revealed: revealed)
    }

    @Test func pointerOverThePreviewOfARevealedBarKeepsIt() {
        #expect(reveals(CGPoint(x: 960, y: 150), revealed: true, preview: previewFrame))
    }

    @Test func pointerInTheGapBetweenTheBarAndItsPreviewKeepsIt() {
        #expect(reveals(CGPoint(x: 960, y: 56), revealed: true, preview: previewFrame))
    }

    @Test func pointerBesideThePreviewOfARevealedBarDoesNotKeepIt() {
        #expect(reveals(CGPoint(x: 500, y: 150), revealed: true, preview: previewFrame) == false)
    }

    @Test func pointerAboveThePreviewOfARevealedBarDoesNotKeepIt() {
        #expect(reveals(CGPoint(x: 960, y: 300), revealed: true, preview: previewFrame) == false)
    }

    @Test func pointerOverThePreviewsPlaceDoesNotRevealAConcealedBar() {
        #expect(reveals(CGPoint(x: 960, y: 150), preview: previewFrame) == false)
    }

    @Test func aRevealedBarWithNoPreviewHidesAboveItself() {
        #expect(reveals(CGPoint(x: 960, y: 150), revealed: true) == false)
    }

    @Test func pointerAtTheBottomEdgeRevealsABottomBar() {
        #expect(reveals(CGPoint(x: 960, y: 0)))
    }

    @Test func pointerInTheMiddleOfTheScreenDoesNotReveal() {
        #expect(reveals(CGPoint(x: 960, y: 540)) == false)
    }

    @Test func pointerOverTheRevealedBarKeepsItRevealed() {
        #expect(reveals(CGPoint(x: 960, y: 30), revealed: true))
    }

    @Test func pointerOverTheStripOfAConcealedBarDoesNotRevealIt() {
        #expect(reveals(CGPoint(x: 960, y: 30)) == false)
    }

    @Test func pointerAtTheEdgeRevealsAConcealedBarWhateverTheStrip() {
        #expect(reveals(CGPoint(x: 960, y: 1)))
    }

    @Test func theEdgeAwayFromTheBarDoesNotReveal() {
        #expect(reveals(CGPoint(x: 960, y: 1080)) == false)
    }

    @Test func pointerOnAnotherDisplayDoesNotReveal() {
        #expect(reveals(CGPoint(x: 2500, y: 0)) == false)
        #expect(reveals(CGPoint(x: 2500, y: 0), revealed: true) == false)
    }

    @Test func aConcealedBarSitsJustOffItsOwnEdge() {
        #expect(
            BarRevealPolicy.concealedFrame(barFrame, edge: .bottom)
                == CGRect(x: 400, y: -52, width: 1120, height: 52)
        )
        #expect(
            BarRevealPolicy.concealedFrame(barFrame, edge: .top)
                == CGRect(x: 400, y: 52, width: 1120, height: 52)
        )
        #expect(
            BarRevealPolicy.concealedFrame(barFrame, edge: .leading)
                == CGRect(x: -720, y: 0, width: 1120, height: 52)
        )
    }

    @Test func eachEdgeRevealsFromItsOwnSide() {
        #expect(reveals(CGPoint(x: 960, y: 1080), edge: .top))
        #expect(reveals(CGPoint(x: 0, y: 540), edge: .leading))
        #expect(reveals(CGPoint(x: 1920, y: 540), edge: .trailing))
    }
}
