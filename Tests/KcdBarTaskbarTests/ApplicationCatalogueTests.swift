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

struct ApplicationCatalogueTests {
    private func application(
        _ bundleIdentifier: String,
        _ displayName: String,
        _ path: String = "/Applications"
    ) -> InstalledApplication {
        InstalledApplication(
            bundleIdentifier: bundleIdentifier,
            displayName: displayName,
            path: path
        )
    }

    @Test func mergeKeepsTheFirstSourceToClaimABundleIdentifier() {
        let directory = application("com.example.app", "Example", "/Applications/Example.app")
        let spotlight = application("com.example.app", "Example", "/Users/paras/Applications/Example.app")

        let merged = ApplicationCatalogue.merged([directory, spotlight])

        #expect(merged.count == 1)
        #expect(merged.first?.path == "/Applications/Example.app")
    }

    @Test func mergeKeepsApplicationsThatOnlyOneSourceFound() {
        let shared = application("com.example.shared", "Shared")
        let setapp = application("com.example.setapp", "Setapp App", "/Users/paras/Applications/Setapp")

        let merged = ApplicationCatalogue.merged([shared, setapp, shared])

        #expect(merged.count == 2)
        #expect(Set(merged.map(\.bundleIdentifier)) == ["com.example.shared", "com.example.setapp"])
    }

    @Test func mergeReturnsItsResultSorted() {
        let merged = ApplicationCatalogue.merged([
            application("com.example.zed", "Zed"),
            application("com.example.alpha", "Alpha"),
            application("com.example.mid", "Mid")
        ])

        #expect(merged.map(\.displayName) == ["Alpha", "Mid", "Zed"])
    }

    @Test func sortIgnoresCase() {
        let sorted = ApplicationCatalogue.sorted([
            application("com.example.b", "beta"),
            application("com.example.a", "Alpha")
        ])

        #expect(sorted.map(\.displayName) == ["Alpha", "beta"])
    }

    @Test func namesThatCompareTheSameFallBackToTheBundleIdentifier() {
        let upper = application("com.example.upper", "Notes")
        let lower = application("com.example.lower", "notes")

        let forwards = ApplicationCatalogue.sorted([upper, lower])
        let backwards = ApplicationCatalogue.sorted([lower, upper])

        #expect(forwards.map(\.bundleIdentifier) == ["com.example.lower", "com.example.upper"])
        #expect(backwards.map(\.bundleIdentifier) == ["com.example.lower", "com.example.upper"])
    }

    @Test func sectionsBandApplicationsUnderTheirInitial() {
        let sections = ApplicationCatalogue.sections(of: [
            application("com.example.a", "Automator"),
            application("com.example.b", "Books"),
            application("com.example.a2", "Airport")
        ])

        #expect(sections.map(\.key) == ["A", "B"])
        #expect(sections.first?.applications.map(\.displayName) == ["Airport", "Automator"])
    }

    @Test func theDigitBandLeadsTheLetters() {
        let sections = ApplicationCatalogue.sections(of: [
            application("com.example.numbers", "1Password"),
            application("com.example.a", "Automator")
        ])

        #expect(sections.map(\.key) == [StartMenuMetrics.otherSectionKey, "A"])
    }

    @Test func sectionsAreEmptyWhenNothingWasFound() {
        #expect(ApplicationCatalogue.sections(of: []).isEmpty)
    }
}
