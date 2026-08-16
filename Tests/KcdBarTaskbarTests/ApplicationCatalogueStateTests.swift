import Testing
@testable import KcdBarTaskbar

@MainActor
struct ApplicationCatalogueStateTests {
    @MainActor
    private final class CountingCatalogue: ApplicationCataloguePort {
        var scans = 0
        var duringScan: (@MainActor () -> Void)?

        func installedApplications() async -> [InstalledApplication] {
            scans += 1
            let hook = duringScan
            duringScan = nil
            hook?()

            return [
                InstalledApplication(
                    bundleIdentifier: "com.example.app",
                    displayName: "Example",
                    path: "/Applications/Example.app"
                )
            ]
        }
    }

    @MainActor
    private final class RecordingWatcher: ApplicationCatalogueWatchPort {
        private(set) var isWatching = false

        func watch(_ onChange: @escaping @MainActor () -> Void) { isWatching = true }
        func stopWatching() { isWatching = false }
    }

    @Test func theFirstOpenScansAndTheNextOneDoesNot() async {
        let catalogue = CountingCatalogue()
        let state = ApplicationCatalogueState(catalogue: catalogue)

        await state.load()
        await state.load()

        #expect(catalogue.scans == 1)
        #expect(state.applications.count == 1)
        #expect(!state.isLoading)
    }

    @Test func loadingStartsWatchingForInstallsAndRemovals() async {
        let watcher = RecordingWatcher()
        let state = ApplicationCatalogueState(catalogue: CountingCatalogue(), watcher: watcher)

        #expect(!watcher.isWatching)

        await state.load()

        #expect(watcher.isWatching)
    }

    @Test func changesArrivingDuringAScanCostOneMoreScan() async {
        let catalogue = CountingCatalogue()
        let state = ApplicationCatalogueState(catalogue: catalogue)
        catalogue.duringScan = { [weak state] in
            state?.catalogueChanged()
            state?.catalogueChanged()
            state?.catalogueChanged()
        }

        await state.reload()

        #expect(catalogue.scans == 2)
    }
}
