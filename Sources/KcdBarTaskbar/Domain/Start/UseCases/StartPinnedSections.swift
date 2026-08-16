/** The pinned pane's bands — a pin sits under the category of the application it points at. */
package enum StartPinnedSections {
    package static func of(
        _ pinned: [PinnedApp],
        categories: [String: ApplicationCategory]
    ) -> [ApplicationSection] {
        let members = pinned.map { pin in
            InstalledApplication(
                bundleIdentifier: pin.bundleIdentifier,
                displayName: pin.displayName,
                path: "",
                category: categories[pin.bundleIdentifier] ?? .other
            )
        }
        let grouped = Dictionary(grouping: members, by: \.category)

        return ApplicationCategory.allCases.compactMap { category in
            guard let band = grouped[category], !band.isEmpty else { return nil }

            return ApplicationSection(
                key: category.rawValue,
                titleKey: category.titleKey,
                applications: band
            )
        }
    }
}
