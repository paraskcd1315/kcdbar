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

struct MergedApplicationSourceTests {
    private struct FixedSource: ApplicationCataloguePort {
        let applications: [InstalledApplication]

        func installedApplications() async -> [InstalledApplication] { applications }
    }

    private func application(
        _ bundleIdentifier: String,
        _ displayName: String,
        _ path: String
    ) -> InstalledApplication {
        InstalledApplication(
            bundleIdentifier: bundleIdentifier,
            displayName: displayName,
            path: path
        )
    }

    @Test func theEarlierSourceOwnsAnApplicationBothOfThemFound() async {
        let directory = FixedSource(applications: [
            application("com.example.app", "Example", "/Applications/Example.app")
        ])
        let indexed = FixedSource(applications: [
            application("com.example.app", "Example", "/Users/paras/Applications/Example.app")
        ])

        let merged = await MergedApplicationSource([directory, indexed]).installedApplications()

        #expect(merged.count == 1)
        #expect(merged.first?.path == "/Applications/Example.app")
    }

    @Test func anApplicationOnlyTheIndexKnowsAboutStillReachesTheList() async {
        let directory = FixedSource(applications: [
            application("com.example.app", "Example", "/Applications/Example.app")
        ])
        let indexed = FixedSource(applications: [
            application("com.example.setapp", "Paste", "/Users/paras/Applications/Setapp/Paste.app")
        ])

        let merged = await MergedApplicationSource([directory, indexed]).installedApplications()

        #expect(merged.map(\.displayName) == ["Example", "Paste"])
    }

    @Test func noSourcesIsAnEmptyList() async {
        let merged = await MergedApplicationSource([]).installedApplications()

        #expect(merged.isEmpty)
    }
}
