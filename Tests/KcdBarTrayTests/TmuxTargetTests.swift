import Testing

@testable import KcdBarTray

struct TmuxTargetTests {
    @Test func anAddressSplitsIntoTheTwoTargetsSelectingItTakes() {
        let target = TmuxTarget.of("ClaudeContext:@0.%0")

        #expect(target?.window == "ClaudeContext:@0")
        #expect(target?.pane == "%0")
    }

    @Test func aSessionNameCarryingADotSplitsOnTheLastOne() {
        let target = TmuxTarget.of("my.project:@3.%12")

        #expect(target?.window == "my.project:@3")
        #expect(target?.pane == "%12")
    }

    @Test func anAddressWithNoPaneIsRefusedRatherThanGuessedAt() {
        #expect(TmuxTarget.of("ClaudeContext:@0") == nil)
    }

    @Test func anEmptyAddressIsRefused() {
        #expect(TmuxTarget.of("") == nil)
    }

    @Test func anAddressEndingInADotIsRefused() {
        #expect(TmuxTarget.of("ClaudeContext:@0.") == nil)
    }

    @Test func anAddressBeginningWithADotIsRefused() {
        #expect(TmuxTarget.of(".%0") == nil)
    }

    @Test func surroundingSpaceIsTrimmedRatherThanSentToTmux() {
        #expect(TmuxTarget.of("  ClaudeContext:@0.%0  ")?.pane == "%0")
    }
}
