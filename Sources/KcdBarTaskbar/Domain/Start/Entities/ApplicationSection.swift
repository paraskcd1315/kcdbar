/** One alphabetical band of the all-applications list. */
package struct ApplicationSection: Equatable, Sendable, Identifiable {
    package var key: String
    package var applications: [InstalledApplication]

    package init(key: String, applications: [InstalledApplication]) {
        self.key = key
        self.applications = applications
    }

    package var id: String { key }
}
