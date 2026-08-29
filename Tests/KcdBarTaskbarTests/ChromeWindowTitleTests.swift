import Testing

@testable import KcdBarTaskbar

struct ChromeWindowTitleTests {
    @Test func theProfileIsTheLastPartOfChromesAccessibilityTitle() {
        #expect(ChromeWindowTitle.profile(of: "Nueva pestaña - Google Chrome - Paras (Tu Chrome)") == "Paras (Tu Chrome)")
        #expect(ChromeWindowTitle.profile(of: "Nuevo chat - Claude - Google Chrome - Paras") == "Paras")
    }

    @Test func aPageTitleCarryingTheSeparatorStillYieldsTheLastPart() {
        #expect(ChromeWindowTitle.profile(of: "A - Google Chrome - B - Google Chrome - Work") == "Work")
    }

    @Test func aTitleWithoutTheSeparatorHasNoProfile() {
        #expect(ChromeWindowTitle.profile(of: "Nueva pestaña") == nil)
        #expect(ChromeWindowTitle.profile(of: "Untitled - Google Chrome - ") == nil)
        #expect(ChromeWindowTitle.profile(of: nil) == nil)
    }
}
