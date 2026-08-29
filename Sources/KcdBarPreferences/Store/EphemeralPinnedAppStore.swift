import Foundation
import KcdBarTaskbar

/** Stands in when the store file cannot be opened, so the bar still runs. */
package actor EphemeralPinnedAppStore:
    PinnedAppStorePort,
    StartPinStorePort,
    StartGroupStorePort,
    ApplicationUsageStorePort,
    PresetStorePort,
    QuitExclusionStorePort,
    DockSnapshotStorePort {
    package init() {}

    private var dockSnapshot: DockSettingsSnapshot?

    package func snapshot() async -> DockSettingsSnapshot? {
        dockSnapshot
    }

    package func remember(_ snapshot: DockSettingsSnapshot) async {
        dockSnapshot = snapshot
    }

    package func clear() async {
        dockSnapshot = nil
    }

    private var exclusions: [QuitExclusion] = []

    package func quitExclusions() async -> [QuitExclusion] {
        exclusions.sorted { $0.displayName < $1.displayName }
    }

    package func exclude(_ exclusion: QuitExclusion) async {
        exclusions.removeAll { $0.bundleIdentifier == exclusion.bundleIdentifier }
        exclusions.append(exclusion)
    }

    package func include(bundleIdentifier: String) async {
        exclusions.removeAll { $0.bundleIdentifier == bundleIdentifier }
    }

    private var savedPresets: [BarPreset] = []
    private var activePresetName = BarPresetCatalogue.default.name

    package func presets() async -> [BarPreset] {
        let savedNames = Set(savedPresets.map(\.name))

        return BarPresetCatalogue.all.filter { !savedNames.contains($0.name) } + savedPresets
    }

    package func save(_ preset: BarPreset) async {
        savedPresets.removeAll { $0.name == preset.name }
        savedPresets.append(preset)
    }

    package func remove(named name: String) async {
        savedPresets.removeAll { $0.name == name }
    }

    package func activePreset() async -> BarPreset {
        await presets().first { $0.name == activePresetName } ?? BarPresetCatalogue.default
    }

    package func setActivePreset(named name: String) async {
        activePresetName = name
    }

    private var apps: [PinnedApp] = []
    private var startApps: [PinnedApp] = []

    package func pinnedApps() async -> [PinnedApp] {
        apps.sorted { $0.order < $1.order }
    }

    package func pin(_ app: PinnedApp) async {
        apps.removeAll { $0.bundleIdentifier == app.bundleIdentifier }
        apps.append(app)
    }

    package func unpin(bundleIdentifier: String) async {
        apps.removeAll { $0.bundleIdentifier == bundleIdentifier }
    }

    package func reorder(_ apps: [PinnedApp]) async {
        self.apps = apps
    }

    package func startPins() async -> [PinnedApp] {
        startApps.sorted { $0.order < $1.order }
    }

    package func pinToStart(_ app: PinnedApp) async {
        startApps.removeAll { $0.bundleIdentifier == app.bundleIdentifier }
        startApps.append(app)
    }

    package func unpinFromStart(bundleIdentifier: String) async {
        startApps.removeAll { $0.bundleIdentifier == bundleIdentifier }
    }

    package func reorderStartPins(_ apps: [PinnedApp]) async {
        startApps = apps
    }

    private var groups: [StartGroup] = []
    private var memberships: [StartGroupMembership] = []

    package func startGroups() async -> [StartGroup] {
        groups.sorted { $0.order < $1.order }
    }

    package func saveStartGroup(_ group: StartGroup) async {
        groups.removeAll { $0.id == group.id }
        groups.append(group)
    }

    package func deleteStartGroup(id: String) async {
        groups.removeAll { $0.id == id }
        memberships.removeAll { $0.groupId == id }
    }

    package func startGroupMemberships() async -> [StartGroupMembership] {
        memberships
    }

    package func saveStartGroupMembership(_ membership: StartGroupMembership) async {
        memberships.removeAll { $0.bundleIdentifier == membership.bundleIdentifier }
        memberships.append(membership)
    }

    package func clearStartGroupMembership(bundleIdentifier: String) async {
        memberships.removeAll { $0.bundleIdentifier == bundleIdentifier }
    }

    private var usage: [ApplicationUsage] = []

    package func applicationUsage() async -> [ApplicationUsage] {
        usage
    }

    package func recordLaunch(bundleIdentifier: String, at moment: Date) async {
        let held = usage.first { $0.bundleIdentifier == bundleIdentifier }
        usage.removeAll { $0.bundleIdentifier == bundleIdentifier }
        usage.append(
            ApplicationUsage(
                bundleIdentifier: bundleIdentifier,
                count: (held?.count ?? 0) + 1,
                lastLaunchedAt: moment
            )
        )
    }
}
