import Foundation

/** Reads the application directories on disk, one level into the folders vendors install into. */
package struct DirectoryApplicationSource: ApplicationCataloguePort {
    package init() {}

    package func installedApplications() async -> [InstalledApplication] {
        let manager = FileManager.default
        let roots = ApplicationDirectories.roots(home: manager.homeDirectoryForCurrentUser)
        let found = roots.flatMap { bundles(under: $0, manager: manager, descending: true) }

        return ApplicationCatalogue.merged(
            ApplicationBundleReader.applications(atPaths: found.map(\.path))
        )
    }

    private func bundles(under root: URL, manager: FileManager, descending: Bool) -> [URL] {
        let contents = contentsOf(root, manager: manager)
        let here = contents.filter { $0.pathExtension == ApplicationDirectories.bundleExtension }
        guard descending else { return here }

        let folders = contents.filter {
            $0.pathExtension != ApplicationDirectories.bundleExtension && isDirectory($0)
        }

        return here + folders.flatMap { bundles(under: $0, manager: manager, descending: false) }
    }

    private func contentsOf(_ url: URL, manager: FileManager) -> [URL] {
        (try? manager.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )) ?? []
    }

    private func isDirectory(_ url: URL) -> Bool {
        (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
