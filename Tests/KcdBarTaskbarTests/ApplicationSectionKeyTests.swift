import Testing
@testable import KcdBarTaskbar

struct ApplicationSectionKeyTests {
    @Test func aLetterBandsUnderItsUppercaseForm() {
        #expect(ApplicationSectionKey.of("automator") == "A")
        #expect(ApplicationSectionKey.of("Books") == "B")
    }

    @Test func anAccentedInitialBandsWithItsPlainLetter() {
        #expect(ApplicationSectionKey.of("Épargne") == "E")
        #expect(ApplicationSectionKey.of("Über") == "U")
    }

    @Test func digitsTakeTheOtherBandAndSymbolsDeferToTheLetterBehindThem() {
        #expect(ApplicationSectionKey.of("1Password") == StartMenuMetrics.otherSectionKey)
        #expect(ApplicationSectionKey.of("+Music") == "M")
    }

    @Test func anEmptyNameBandsAsOther() {
        #expect(ApplicationSectionKey.of("") == StartMenuMetrics.otherSectionKey)
    }
}
