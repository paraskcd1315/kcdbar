/** One band of the all-applications list, headed by a letter or by a category's name. */
package struct ApplicationSection: Equatable, Sendable, Identifiable {
    package var key: String
    package var titleKey: String?
    package var applications: [InstalledApplication]

    package init(key: String, titleKey: String? = nil, applications: [InstalledApplication]) {
        self.key = key
        self.titleKey = titleKey
        self.applications = applications
    }

    package var id: String { key }
}
