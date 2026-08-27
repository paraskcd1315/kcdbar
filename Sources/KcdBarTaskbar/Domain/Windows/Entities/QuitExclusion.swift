/** An application the user keeps running after its last window closes. */
package struct QuitExclusion: Equatable, Sendable, Identifiable {
    package let bundleIdentifier: String
    package let displayName: String

    package var id: String { bundleIdentifier }

    package init(bundleIdentifier: String, displayName: String) {
        self.bundleIdentifier = bundleIdentifier
        self.displayName = displayName
    }
}
