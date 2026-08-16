import Foundation

/** Turns application bundle paths into the entries the Start menu lists. */
package enum ApplicationBundleReader {
    package static func applications(atPaths paths: [String]) -> [InstalledApplication] {
        let roots = ApplicationDirectories.roots(
            home: FileManager.default.homeDirectoryForCurrentUser
        )

        return paths.compactMap { application(at: URL(fileURLWithPath: $0), underRoots: roots) }
    }

    package static func application(at url: URL, underRoots roots: [URL]) -> InstalledApplication? {
        guard ApplicationBundleFilter.isListable(path: url.path, underRoots: roots),
              let bundle = Bundle(url: url),
              let identifier = bundle.bundleIdentifier,
              !ApplicationBundleFilter.isBackgroundOnly(bundle)
        else {
            return nil
        }

        let raw = bundle.object(forInfoDictionaryKey: ApplicationBundleMetrics.categoryKey) as? String

        return InstalledApplication(
            bundleIdentifier: identifier,
            displayName: BundleDisplayName.of(bundle, url: url),
            path: url.path,
            category: ApplicationCategory.of(raw)
        )
    }
}
