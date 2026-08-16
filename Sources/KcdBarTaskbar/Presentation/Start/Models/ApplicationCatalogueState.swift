import Foundation
import Observation

/** The Start menu's live view of what is installed. */
@MainActor
@Observable
package final class ApplicationCatalogueState {
    package private(set) var applications: [InstalledApplication] = []
    package private(set) var isLoading = true

    private let catalogue: any ApplicationCataloguePort
    private let watcher: (any ApplicationCatalogueWatchPort)?
    private var isReloading = false
    private var reloadWanted = false

    package init(
        catalogue: any ApplicationCataloguePort,
        watcher: (any ApplicationCatalogueWatchPort)? = nil
    ) {
        self.catalogue = catalogue
        self.watcher = watcher
    }

    package var sections: [ApplicationSection] {
        ApplicationCatalogue.sections(of: applications)
    }

    package func load() async {
        guard applications.isEmpty else { return }

        isLoading = true
        applications = await catalogue.installedApplications()
        isLoading = false
        watcher?.watch { [weak self] in self?.catalogueChanged() }
    }

    package func catalogueChanged() {
        guard !isReloading else {
            reloadWanted = true
            return
        }

        Task { await self.reload() }
    }

    package func reload() async {
        isReloading = true
        repeat {
            reloadWanted = false
            applications = await catalogue.installedApplications()
        } while reloadWanted
        isReloading = false
    }

    package func application(withBundleIdentifier identifier: String) -> InstalledApplication? {
        applications.first { $0.bundleIdentifier == identifier }
    }
}
