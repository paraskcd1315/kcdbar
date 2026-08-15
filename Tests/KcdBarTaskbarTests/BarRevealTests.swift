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

    @Test func pointerAtTheBottomEdgeRevealsABottomBar() {
        let atEdge = CGPoint(x: 960, y: 0)

        #expect(BarRevealPolicy.shouldReveal(pointer: atEdge, barFrame: barFrame, display: display, edge: .bottom))
    }

    @Test func pointerInTheMiddleOfTheScreenDoesNotReveal() {
        let middle = CGPoint(x: 960, y: 540)

        #expect(
            BarRevealPolicy.shouldReveal(pointer: middle, barFrame: barFrame, display: display, edge: .bottom) == false
        )
    }

    @Test func pointerOverTheRevealedBarKeepsItRevealed() {
        let overBar = CGPoint(x: 960, y: 30)

        #expect(BarRevealPolicy.shouldReveal(pointer: overBar, barFrame: barFrame, display: display, edge: .bottom))
    }

    @Test func theEdgeAwayFromTheBarDoesNotReveal() {
        let topEdge = CGPoint(x: 960, y: 1080)

        #expect(
            BarRevealPolicy.shouldReveal(pointer: topEdge, barFrame: barFrame, display: display, edge: .bottom) == false
        )
    }

    @Test func pointerOnAnotherDisplayDoesNotReveal() {
        let elsewhere = CGPoint(x: 2500, y: 0)

        #expect(
            BarRevealPolicy.shouldReveal(pointer: elsewhere, barFrame: barFrame, display: display, edge: .bottom) == false
        )
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
        #expect(
            BarRevealPolicy.shouldReveal(
                pointer: CGPoint(x: 960, y: 1080),
                barFrame: barFrame,
                display: display,
                edge: .top
            )
        )
        #expect(
            BarRevealPolicy.shouldReveal(
                pointer: CGPoint(x: 0, y: 540),
                barFrame: barFrame,
                display: display,
                edge: .leading
            )
        )
        #expect(
            BarRevealPolicy.shouldReveal(
                pointer: CGPoint(x: 1920, y: 540),
                barFrame: barFrame,
                display: display,
                edge: .trailing
            )
        )
    }
}
