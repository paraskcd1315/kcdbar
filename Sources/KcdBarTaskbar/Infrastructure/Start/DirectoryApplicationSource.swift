import AppKit
import Foundation

/** Reads the application directories on disk, which is every app installed in a standard place. */
package struct DirectoryApplicationSource: ApplicationCataloguePort {
    package init() {}

    package func installedApplications() async -> [InstalledApplication] {
        let manager = FileManager.default
        let roots = ApplicationDirectories.roots(home: manager.homeDirectoryForCurrentUser)
        let found = roots.flatMap { bundles(under: $0, manager: manager) }

        return ApplicationCatalogue.merged(found.compactMap(application(at:)))
    }

    private func bundles(under root: URL, manager: FileManager) -> [URL] {
        guard let contents = try? manager.contentsOfDirectory(
            at: root,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        else {
            return []
        }

        return contents.filter { $0.pathExtension == ApplicationDirectories.bundleExtension }
    }

    private func application(at url: URL) -> InstalledApplication? {
        guard let bundle = Bundle(url: url), let identifier = bundle.bundleIdentifier else {
            return nil
        }

        return InstalledApplication(
            bundleIdentifier: identifier,
            displayName: BundleDisplayName.of(bundle, url: url),
            path: url.path
        )
    }
}
