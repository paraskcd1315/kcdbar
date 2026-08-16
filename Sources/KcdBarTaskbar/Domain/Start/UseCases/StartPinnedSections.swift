/** The pinned pane's bands, and the rows that must exist for every pin to have a home. */
package enum StartPinnedSections {
    package static func seeds(
        pins: [PinnedApp],
        groups: [StartGroup],
        memberships: [StartGroupMembership]
    ) -> (groups: [StartGroup], memberships: [StartGroupMembership]) {
        let held = Set(memberships.map(\.bundleIdentifier))
        let homeless = pins.sorted { $0.order < $1.order }
            .filter { !held.contains($0.bundleIdentifier) }
        guard !homeless.isEmpty else { return ([], []) }

        let defaults = groups.contains { $0.id == StartGroupMetrics.defaultGroupId }
            ? []
            : [
                StartGroup(
                    id: StartGroupMetrics.defaultGroupId,
                    titleKey: StartGroupMetrics.defaultGroupTitleKey,
                    order: 0
                )
            ]
        var next = countsByGroup(memberships)[StartGroupMetrics.defaultGroupId, default: 0]
        let fresh = homeless.map { pin -> StartGroupMembership in
            defer { next += 1 }

            return StartGroupMembership(
                bundleIdentifier: pin.bundleIdentifier,
                groupId: StartGroupMetrics.defaultGroupId,
                order: next
            )
        }

        return (defaults, fresh)
    }

    package static func moved(
        _ bands: [StartPinnedBand],
        moving bundleIdentifier: String,
        to groupId: String,
        before target: String?
    ) -> [StartGroupMembership] {
        var members = Dictionary(
            bands.map { ($0.group.id, $0.applications) },
            uniquingKeysWith: { first, _ in first }
        )
        guard let carried = members.values.flatMap({ $0 })
            .first(where: { $0.bundleIdentifier == bundleIdentifier })
        else {
            return []
        }
        for key in members.keys {
            members[key]?.removeAll { $0.bundleIdentifier == bundleIdentifier }
        }
        var destination = members[groupId] ?? []
        let index = target.flatMap { name in
            destination.firstIndex { $0.bundleIdentifier == name }
        } ?? destination.count
        destination.insert(carried, at: index)
        members[groupId] = destination

        return members.flatMap { reordered($1, in: $0) }
    }

    package static func bands(
        pins: [PinnedApp],
        groups: [StartGroup],
        memberships: [StartGroupMembership]
    ) -> [StartPinnedBand] {
        let names = Dictionary(pins.map { ($0.bundleIdentifier, $0) }, uniquingKeysWith: { first, _ in first })
        let byGroup = Dictionary(grouping: memberships.filter { names[$0.bundleIdentifier] != nil }) {
            $0.groupId
        }

        return groups.sorted { $0.order < $1.order }.map { group in
            let applications = (byGroup[group.id] ?? [])
                .sorted { $0.order < $1.order }
                .compactMap { membership -> InstalledApplication? in
                    guard let pin = names[membership.bundleIdentifier] else { return nil }

                    return InstalledApplication(
                        bundleIdentifier: pin.bundleIdentifier,
                        displayName: pin.displayName,
                        path: ""
                    )
                }

            return StartPinnedBand(group: group, applications: applications)
        }
    }

    package static func reordered(
        _ members: [InstalledApplication],
        in groupId: String
    ) -> [StartGroupMembership] {
        members.enumerated().map {
            StartGroupMembership(
                bundleIdentifier: $1.bundleIdentifier,
                groupId: groupId,
                order: $0
            )
        }
    }

    private static func countsByGroup(_ memberships: [StartGroupMembership]) -> [String: Int] {
        memberships.reduce(into: [:]) { counts, membership in
            counts[membership.groupId] = max(counts[membership.groupId] ?? 0, membership.order + 1)
        }
    }

}
