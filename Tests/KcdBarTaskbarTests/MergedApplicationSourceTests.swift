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
