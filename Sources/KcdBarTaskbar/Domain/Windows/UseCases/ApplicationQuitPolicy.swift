/** Which applications macOS lets a launcher quit. */
package enum ApplicationQuitPolicy {
    package static let unquittable: Set<String> = [
        "com.apple.finder",
        "com.apple.dock",
        "com.apple.systemuiserver",
        "com.apple.controlcenter"
    ]

    package static func canQuit(bundleIdentifier: String?) -> Bool {
        guard let bundleIdentifier else { return false }

        return !unquittable.contains(bundleIdentifier)
    }
}
