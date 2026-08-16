/** An application the Start menu can list and launch. */
package struct InstalledApplication: Equatable, Sendable, Identifiable {
    package var bundleIdentifier: String
    package var displayName: String
    package var path: String

    package init(bundleIdentifier: String, displayName: String, path: String) {
        self.bundleIdentifier = bundleIdentifier
        self.displayName = displayName
        self.path = path
    }

    package var id: String { bundleIdentifier }
}
