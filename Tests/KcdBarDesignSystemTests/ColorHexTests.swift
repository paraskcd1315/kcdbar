import SwiftUI
import Testing

@testable import KcdBarDesignSystem

struct ColorHexTests {
    @Test func aSixDigitHexBecomesAColour() {
        #expect(Color(hex: "#0B83D9") != nil)
    }

    @Test func theLeadingHashIsOptional() {
        #expect(Color(hex: "0B83D9") == Color(hex: "#0B83D9"))
    }

    @Test func theCaseOfTheDigitsDoesNotMatter() {
        #expect(Color(hex: "#0b83d9") == Color(hex: "#0B83D9"))
    }

    @Test func aTrackerStatingNoColourGetsNoneRatherThanBlack() {
        #expect(Color(hex: "") == nil)
    }

    @Test func aShorthandHexIsRefusedRatherThanGuessedAt() {
        #expect(Color(hex: "#0BD") == nil)
    }

    @Test func anEightDigitHexIsRefused() {
        #expect(Color(hex: "#FF0B83D9") == nil)
    }

    @Test func somethingThatIsNotHexAtAllIsRefused() {
        #expect(Color(hex: "#ZZZZZZ") == nil)
    }
}
