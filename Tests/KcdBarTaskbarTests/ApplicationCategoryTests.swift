import Testing
@testable import KcdBarTaskbar

struct ApplicationCategoryTests {
    private func application(_ name: String, _ category: ApplicationCategory) -> InstalledApplication {
        InstalledApplication(
            bundleIdentifier: "com.example.\(name)",
            displayName: name,
            path: "/Applications/\(name).app",
            category: category
        )
    }

    @Test func aKnownTypeLandsInItsBand() {
        #expect(ApplicationCategory.of("public.app-category.developer-tools") == .developer)
        #expect(ApplicationCategory.of("public.app-category.social-networking") == .social)
        #expect(ApplicationCategory.of("public.app-category.finance") == .productivity)
        #expect(ApplicationCategory.of("public.app-category.photography") == .creativity)
    }

    @Test func everyKindOfGameIsEntertainment() {
        #expect(ApplicationCategory.of("public.app-category.games") == .entertainment)
        #expect(ApplicationCategory.of("public.app-category.puzzle-games") == .entertainment)
        #expect(ApplicationCategory.of("public.app-category.role-playing-games") == .entertainment)
    }

    @Test func anAppWithoutACategoryIsNotLost() {
        #expect(ApplicationCategory.of(nil) == .other)
        #expect(ApplicationCategory.of("public.app-category.made-this-up") == .other)
        #expect(ApplicationCategory.of("") == .other)
    }

    @Test func everyCategoryHasACatalogueKeyOfItsOwn() {
        let keys = ApplicationCategory.allCases.map(\.titleKey)

        #expect(Set(keys).count == ApplicationCategory.allCases.count)
        #expect(keys.allSatisfy { $0.hasPrefix(ApplicationCategoryMetrics.titlePrefix) })
    }

    @Test func categoryBandsFollowTheEnumsOrderAndSkipTheEmptyOnes() {
        let sections = ApplicationCatalogue.categorySections(of: [
            application("Reeder", .reference),
            application("Xcode", .developer),
            application("Numbers", .productivity)
        ])

        #expect(sections.map(\.key) == ["productivity", "developer", "reference"])
        #expect(sections.allSatisfy { $0.titleKey != nil })
    }

    @Test func eachCategoryBandIsSortedWithinItself() {
        let sections = ApplicationCatalogue.categorySections(of: [
            application("Xcode", .developer),
            application("Ghostty", .developer)
        ])

        #expect(sections.first?.applications.map(\.displayName) == ["Ghostty", "Xcode"])
    }

    @Test func theLetterIndexOffersEveryBandWhetherOrNotItIsFilled() {
        #expect(ApplicationIndexKeys.all.count == 27)
        #expect(ApplicationIndexKeys.all.first == StartMenuMetrics.otherSectionKey)
        #expect(ApplicationIndexKeys.all.last == "Z")
    }
}
