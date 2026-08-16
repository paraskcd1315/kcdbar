import Foundation
import Observation

/** The Start menu's pinned bands — which exist, what they are called, and what sits in them. */
@MainActor
@Observable
package final class StartGroupState {
    package private(set) var groups: [StartGroup] = []
    package private(set) var memberships: [StartGroupMembership] = []
    package private(set) var editing: String?

    private let store: any StartGroupStorePort

    package init(store: any StartGroupStorePort) {
        self.store = store
    }

    package func load() async {
        groups = await store.startGroups()
        memberships = await store.startGroupMemberships()
    }

    package func bands(of pins: [PinnedApp]) -> [StartPinnedBand] {
        StartPinnedSections.bands(pins: pins, groups: groups, memberships: memberships)
    }

    package func seed(pins: [PinnedApp]) async {
        let seeds = StartPinnedSections.seeds(
            pins: pins,
            groups: groups,
            memberships: memberships
        )
        guard !seeds.groups.isEmpty || !seeds.memberships.isEmpty else { return }

        for group in seeds.groups {
            await store.saveStartGroup(group)
        }
        for membership in seeds.memberships {
            await store.saveStartGroupMembership(membership)
        }
        await load()
    }

    package func beginEditing(_ id: String) {
        editing = id
    }

    package func endEditing() {
        editing = nil
    }

    package func cancelEditing() async {
        guard let id = editing else { return }
        editing = nil
        guard let held = groups.first(where: { $0.id == id }),
              held.title == nil,
              !memberships.contains(where: { $0.groupId == id })
        else {
            return
        }

        await remove(id)
    }

    package func rename(_ id: String, to title: String) async {
        editing = nil
        guard let held = groups.first(where: { $0.id == id }) else { return }
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        var renamed = held
        renamed.title = trimmed.isEmpty ? nil : trimmed

        await store.saveStartGroup(renamed)
        await load()
    }

    package func create() async {
        let group = StartGroup(
            id: StartGroupMetrics.freshId(),
            order: (groups.map(\.order).max() ?? -1) + 1
        )

        await store.saveStartGroup(group)
        await load()
        editing = group.id
    }

    package func toggleCollapse(_ id: String) async {
        guard var held = groups.first(where: { $0.id == id }) else { return }
        held.isCollapsed.toggle()

        await store.saveStartGroup(held)
        await load()
    }

    package func remove(_ id: String) async {
        await store.deleteStartGroup(id: id)
        await load()
    }

    package func move(
        _ bundleIdentifier: String,
        to groupId: String,
        before target: String?,
        among bands: [StartPinnedBand]
    ) async {
        let moved = StartPinnedSections.moved(
            bands,
            moving: bundleIdentifier,
            to: groupId,
            before: target
        )
        for membership in moved {
            await store.saveStartGroupMembership(membership)
        }
        await load()
    }
}
