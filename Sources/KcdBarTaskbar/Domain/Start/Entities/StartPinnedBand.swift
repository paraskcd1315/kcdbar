/** One band of the pinned pane: the group that names it and the pins inside it, in order. */
package struct StartPinnedBand: Equatable, Sendable, Identifiable {
    package var group: StartGroup
    package var applications: [InstalledApplication]

    package init(group: StartGroup, applications: [InstalledApplication]) {
        self.group = group
        self.applications = applications
    }

    package var id: String { group.id }
}
