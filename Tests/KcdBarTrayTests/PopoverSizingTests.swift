import CoreGraphics
import Testing

@testable import KcdBarTray

struct PopoverSizingTests {
    @Test func anIdenticalMeasurementDoesNotResizeTheWindow() {
        let size = CGSize(width: 340, height: 420)

        #expect(PopoverSizing.isSettled(size, against: size))
    }

    @Test func aSubPointDifferenceDoesNotResizeTheWindow() {
        #expect(
            PopoverSizing.isSettled(
                CGSize(width: 340.4, height: 420.2),
                against: CGSize(width: 340, height: 420)
            )
        )
    }

    @Test func aRealGrowthResizesTheWindow() {
        #expect(
            !PopoverSizing.isSettled(
                CGSize(width: 340, height: 520),
                against: CGSize(width: 340, height: 420)
            )
        )
    }

    @Test func aFirstMeasurementAlwaysResizes() {
        #expect(!PopoverSizing.isSettled(CGSize(width: 340, height: 420), against: .zero))
    }
}
