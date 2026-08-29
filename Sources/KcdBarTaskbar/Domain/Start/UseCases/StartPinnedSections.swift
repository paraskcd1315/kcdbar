// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
        rearranged(bands, moving: bundleIdentifier, to: groupId, before: target)
            .flatMap { reordered($1, in: $0) }
    }

    package static func previewing(
        _ bands: [StartPinnedBand],
        moving bundleIdentifier: String,
        to groupId: String,
        before target: String?
    ) -> [StartPinnedBand] {
        let members = rearranged(bands, moving: bundleIdentifier, to: groupId, before: target)

        return bands.map { StartPinnedBand(group: $0.group, applications: members[$0.group.id] ?? []) }
    }

    private static func rearranged(
        _ bands: [StartPinnedBand],
        moving bundleIdentifier: String,
        to groupId: String,
        before target: String?
    ) -> [String: [InstalledApplication]] {
        var members = Dictionary(
            bands.map { ($0.group.id, $0.applications) },
            uniquingKeysWith: { first, _ in first }
        )
        guard let carried = members.values.flatMap({ $0 })
            .first(where: { $0.bundleIdentifier == bundleIdentifier })
        else {
            return members
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

        return members
    }

    package static func bands(
        pins: [PinnedApp],
        groups: [StartGroup],
        memberships: [StartGroupMembership]
    ) -> [StartPinnedBand] {
        let names = Dictionary(pins.map { ($0.bundleIdentifier, $0) }, uniquingKeysWith: { first, _ in first })
        let held = Set(memberships.map(\.bundleIdentifier))
        let homeless = pins
            .filter { !held.contains($0.bundleIdentifier) }
            .sorted { $0.order < $1.order }
        let placed = memberships.filter { names[$0.bundleIdentifier] != nil } + homeless.enumerated().map {
            StartGroupMembership(
                bundleIdentifier: $1.bundleIdentifier,
                groupId: StartGroupMetrics.defaultGroupId,
                order: countsByGroup(memberships)[StartGroupMetrics.defaultGroupId, default: 0] + $0
            )
        }
        let byGroup = Dictionary(grouping: placed) { $0.groupId }
        let known = homeless.isEmpty || groups.contains { $0.id == StartGroupMetrics.defaultGroupId }
            ? groups
            : groups + [
                StartGroup(
                    id: StartGroupMetrics.defaultGroupId,
                    titleKey: StartGroupMetrics.defaultGroupTitleKey,
                    order: -1
                )
            ]

        return known.sorted { $0.order < $1.order }.map { group in
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
