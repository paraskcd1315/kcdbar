/** Every source the Start menu has, folded into the one list it shows. */
package struct MergedApplicationSource: ApplicationCataloguePort {
    private let sources: [any ApplicationCataloguePort]

    package init(_ sources: [any ApplicationCataloguePort]) {
        self.sources = sources
    }

    package func installedApplications() async -> [InstalledApplication] {
        var found: [InstalledApplication] = []
        for source in sources {
            found += await source.installedApplications()
        }

        return ApplicationCatalogue.merged(found)
    }
}
