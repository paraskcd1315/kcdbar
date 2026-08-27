import CoreGraphics
import Testing
@testable import KcdBarTaskbar

struct DisplayFlipReferenceTests {
    @Test func thePrimaryDisplaysTopIsTheReference() {
        let displays = [
            DisplayGeometry(id: 2, frame: CGRect(x: 1920, y: -180, width: 1920, height: 1080), isPrimary: false),
            DisplayGeometry(id: 1, frame: CGRect(x: 0, y: 0, width: 1440, height: 900), isPrimary: true),
        ]

        #expect(DisplayFlipReference.of(displays) == 900)
    }

    @Test func noDisplaysFlipAgainstZero() {
        #expect(DisplayFlipReference.of([]) == 0)
    }
}
