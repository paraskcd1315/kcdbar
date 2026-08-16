import Foundation
import Observation

/** The Start menu's live view of what is installed. */
@MainActor
@Observable
package final class ApplicationCatalogueState {
    package private(set) var applications: [InstalledApplication] = []
    package private(set) var isLoading = true
    package private(set) var grouping: StartMenuGrouping = .alphabetical
    package private(set) var layout: StartMenuLayout = .list
    package private(set) var openedCategory: String?
    package private(set) var visibleKey: String?

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
        switch grouping {
        case .alphabetical: ApplicationCatalogue.sections(of: applications)
        case .category: ApplicationCatalogue.categorySections(of: applications)
        }
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

    package var openedSection: ApplicationSection? {
        guard let openedCategory else { return nil }

        return sections.first { $0.key == openedCategory }
    }

    package var visibleSections: [ApplicationSection] {
        openedSection.map { [$0] } ?? sections
    }

    package var showsFolders: Bool {
        grouping == .category && layout == .grid && openedCategory == nil && !isLoading
    }

    package func choose(_ grouping: StartMenuGrouping) {
        self.grouping = grouping
        openedCategory = nil
        guard grouping == .category else { return }

        layout = .grid
    }

    package func choose(_ layout: StartMenuLayout) {
        self.layout = layout
        openedCategory = nil
    }

    package func note(visible key: String?) {
        visibleKey = key
    }

    package var indexKey: String {
        visibleKey ?? sections.first?.key ?? StartMenuMetrics.otherSectionKey
    }

    package func open(category: String) {
        openedCategory = category
    }

    package func closeCategory() {
        openedCategory = nil
    }

    package func application(withBundleIdentifier identifier: String) -> InstalledApplication? {
        applications.first { $0.bundleIdentifier == identifier }
    }
}
