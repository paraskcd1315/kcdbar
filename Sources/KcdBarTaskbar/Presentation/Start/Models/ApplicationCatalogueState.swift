import Foundation
import Observation

/** The Start menu's live view of what is installed. */
@MainActor
@Observable
package final class ApplicationCatalogueState {
    package private(set) var applications: [InstalledApplication] = []
    package private(set) var isLoading = true

    private let catalogue: any ApplicationCataloguePort

    package init(catalogue: any ApplicationCataloguePort) {
        self.catalogue = catalogue
    }

    package var sections: [ApplicationSection] {
        ApplicationCatalogue.sections(of: applications)
    }

    package func load() async {
        guard applications.isEmpty else { return }

        isLoading = true
        applications = await catalogue.installedApplications()
        isLoading = false
    }

    package func reload() async {
        applications = await catalogue.installedApplications()
    }

    package func application(withBundleIdentifier identifier: String) -> InstalledApplication? {
        applications.first { $0.bundleIdentifier == identifier }
    }
}
