import Testing
@testable import KcdBarTaskbar

struct StartPinnedSectionsTests {
    private func pin(_ identifier: String, _ name: String, _ order: Int) -> PinnedApp {
        PinnedApp(bundleIdentifier: identifier, displayName: name, order: order)
    }

    @Test func pinsBandUnderTheCategoryOfTheApplicationTheyPointAt() {
        let sections = StartPinnedSections.of(
            [pin("com.example.xcode", "Xcode", 0), pin("com.example.numbers", "Numbers", 1)],
            categories: [
                "com.example.xcode": .developer,
                "com.example.numbers": .productivity
            ]
        )

        #expect(sections.map(\.key) == ["productivity", "developer"])
        #expect(sections.allSatisfy { $0.titleKey != nil })
    }

    @Test func aPinForAnApplicationTheCatalogueHasNotSeenStillShows() {
        let sections = StartPinnedSections.of(
            [pin("com.example.gone", "Gone", 0)],
            categories: [:]
        )

        #expect(sections.map(\.key) == [ApplicationCategory.other.rawValue])
        #expect(sections.first?.applications.first?.displayName == "Gone")
    }

    @Test func noPinsIsNoBands() {
        #expect(StartPinnedSections.of([], categories: [:]).isEmpty)
    }

    @Test func aBandKeepsEveryPinItHolds() {
        let sections = StartPinnedSections.of(
            [pin("a", "Ghostty", 0), pin("b", "Xcode", 1)],
            categories: ["a": .developer, "b": .developer]
        )

        #expect(sections.count == 1)
        #expect(sections.first?.applications.count == 2)
    }
}
