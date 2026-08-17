/** An application the Start menu can list and launch. */
package struct InstalledApplication: Equatable, Sendable, Identifiable {
    package var bundleIdentifier: String
    package var displayName: String
    package var path: String
    package var category: ApplicationCategory

    package init(
        bundleIdentifier: String,
        displayName: String,
        path: String,
        category: ApplicationCategory = .other
    ) {
        self.bundleIdentifier = bundleIdentifier
        self.displayName = displayName
        self.path = path
        self.category = category
    }

    package var id: String { bundleIdentifier }
}
