// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
