import Testing
@testable import KcdBarTaskbar

struct ApplicationSortKeyTests {
    @Test func aLeftToRightMarkIsNotPartOfAName() {
        let whatsApp = "\u{200E}WhatsApp"

        #expect(ApplicationDisplayName.cleaned(whatsApp) == "WhatsApp")
        #expect(ApplicationSortKey.of(whatsApp) == "WhatsApp")
        #expect(ApplicationSectionKey.of(whatsApp) == "W")
    }

    @Test func aLeadingSymbolIsSkippedRatherThanBanded() {
        #expect(ApplicationSortKey.of("•Focus") == "Focus")
        #expect(ApplicationSectionKey.of("•Focus") == "F")
        #expect(ApplicationSectionKey.of("+Music") == "M")
    }

    @Test func aLeadingDigitIsStillADigit() {
        #expect(ApplicationSortKey.of("1Password") == "1Password")
        #expect(ApplicationSectionKey.of("1Password") == StartMenuMetrics.otherSectionKey)
    }

    @Test func aNameOfNothingButMarksIsKeptRatherThanEmptied() {
        #expect(ApplicationDisplayName.cleaned("\u{200E}\u{200F}") == "\u{200E}\u{200F}")
        #expect(ApplicationSectionKey.of("\u{200E}\u{200F}") == StartMenuMetrics.otherSectionKey)
    }

    @Test func aMarkedNameSortsWhereItsLettersPutIt() {
        let sorted = ApplicationCatalogue.sorted([
            InstalledApplication(bundleIdentifier: "a", displayName: "\u{200E}WhatsApp", path: "/a"),
            InstalledApplication(bundleIdentifier: "b", displayName: "Activity Monitor", path: "/b"),
            InstalledApplication(bundleIdentifier: "c", displayName: "Safari", path: "/c")
        ])

        #expect(sorted.map(\.bundleIdentifier) == ["b", "c", "a"])
    }
}
