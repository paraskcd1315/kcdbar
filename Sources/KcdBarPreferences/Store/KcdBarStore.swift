import Foundation
import KcdBarTaskbar
import SwiftData

/** Everything KCDBar remembers between launches. */
@ModelActor
actor KcdBarStore:
    PresetStorePort,
    DockSnapshotStorePort,
    PinnedAppStorePort,
    StartPinStorePort,
    StartGroupStorePort,
    ApplicationUsageStorePort,
    QuitExclusionStorePort {
    package static let fileName = "kcdbar.store"

    static func container(at url: URL? = nil, inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            StoredPreset.self,
            StoredDockSnapshot.self,
            StoredPreferences.self,
            StoredPinnedApp.self,
            StoredStartPin.self,
            StoredStartGroup.self,
            StoredStartGroupMembership.self,
            StoredApplicationUsage.self,
            StoredQuitExclusion.self
        ])
        let configuration = inMemory
            ? ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            : ModelConfiguration(schema: schema, url: url ?? defaultLocation())

        return try ModelContainer(for: schema, configurations: [configuration])
    }

    static func opened(at url: URL? = nil) -> ModelContainer? {
        try? container(at: url)
    }

    static func defaultLocation() -> URL {
        let support = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first ?? URL(fileURLWithPath: NSTemporaryDirectory())
        let folder = support.appendingPathComponent("KCDBar", isDirectory: true)

        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        return folder.appendingPathComponent(fileName)
    }

    func presets() async -> [BarPreset] {
        let stored = (try? modelContext.fetch(FetchDescriptor<StoredPreset>())) ?? []
        let saved = stored.compactMap { decode($0.payload) }
        let savedNames = Set(saved.map(\.name))

        return BarPresetCatalogue.all.filter { !savedNames.contains($0.name) } + saved
    }

    func save(_ preset: BarPreset) async {
        guard let payload = encode(preset) else { return }

        if let held = storedPreset(named: preset.name) {
            held.payload = payload
        } else {
            modelContext.insert(
                StoredPreset(
                    name: preset.name,
                    payload: payload,
                    isBuiltIn: BarPresetCatalogue.all.contains { $0.name == preset.name }
                )
            )
        }
        try? modelContext.save()
    }

    func remove(named name: String) async {
        guard let held = storedPreset(named: name) else { return }

        modelContext.delete(held)
        try? modelContext.save()
    }

    func activePreset() async -> BarPreset {
        let name = preferences().activePresetName
        let all = await presets()

        return all.first { $0.name == name } ?? BarPresetCatalogue.default
    }

    func setActivePreset(named name: String) async {
        preferences().activePresetName = name
        try? modelContext.save()
    }

    func snapshot() async -> DockSettingsSnapshot? {
        guard let held = storedSnapshot() else { return nil }

        return try? JSONDecoder().decode(DockSettingsSnapshot.self, from: held.payload)
    }

    func remember(_ snapshot: DockSettingsSnapshot) async {
        guard let payload = try? JSONEncoder().encode(snapshot) else { return }

        if let held = storedSnapshot() {
            held.payload = payload
        } else {
            modelContext.insert(StoredDockSnapshot(payload: payload))
        }
        try? modelContext.save()
    }

    func clear() async {
        guard let held = storedSnapshot() else { return }

        modelContext.delete(held)
        try? modelContext.save()
    }

    func pinnedApps() async -> [PinnedApp] {
        let stored = (try? modelContext.fetch(FetchDescriptor<StoredPinnedApp>())) ?? []

        return stored
            .sorted { $0.order < $1.order }
            .map {
                PinnedApp(
                    bundleIdentifier: $0.bundleIdentifier,
                    displayName: $0.displayName,
                    order: $0.order
                )
            }
    }

    func pin(_ app: PinnedApp) async {
        if let held = storedPin(bundleIdentifier: app.bundleIdentifier) {
            held.order = app.order
            held.displayName = app.displayName
        } else {
            modelContext.insert(
                StoredPinnedApp(
                    bundleIdentifier: app.bundleIdentifier,
                    order: app.order,
                    displayName: app.displayName
                )
            )
        }
        try? modelContext.save()
    }

    func unpin(bundleIdentifier: String) async {
        guard let held = storedPin(bundleIdentifier: bundleIdentifier) else { return }

        modelContext.delete(held)
        try? modelContext.save()
    }

    func reorder(_ apps: [PinnedApp]) async {
        for app in apps {
            storedPin(bundleIdentifier: app.bundleIdentifier)?.order = app.order
        }
        try? modelContext.save()
    }

    func startPins() async -> [PinnedApp] {
        let stored = (try? modelContext.fetch(FetchDescriptor<StoredStartPin>())) ?? []

        return stored
            .sorted { $0.order < $1.order }
            .map {
                PinnedApp(
                    bundleIdentifier: $0.bundleIdentifier,
                    displayName: $0.displayName,
                    order: $0.order
                )
            }
    }

    func pinToStart(_ app: PinnedApp) async {
        if let held = storedStartPin(bundleIdentifier: app.bundleIdentifier) {
            held.order = app.order
            held.displayName = app.displayName
        } else {
            modelContext.insert(
                StoredStartPin(
                    bundleIdentifier: app.bundleIdentifier,
                    order: app.order,
                    displayName: app.displayName
                )
            )
        }
        try? modelContext.save()
    }

    func unpinFromStart(bundleIdentifier: String) async {
        guard let held = storedStartPin(bundleIdentifier: bundleIdentifier) else { return }

        modelContext.delete(held)
        try? modelContext.save()
    }

    func reorderStartPins(_ apps: [PinnedApp]) async {
        for app in apps {
            storedStartPin(bundleIdentifier: app.bundleIdentifier)?.order = app.order
        }
        try? modelContext.save()
    }

    func startGroups() async -> [StartGroup] {
        let stored = (try? modelContext.fetch(FetchDescriptor<StoredStartGroup>())) ?? []

        return stored
            .sorted { $0.order < $1.order }
            .map {
                StartGroup(
                    id: $0.id,
                    title: $0.title,
                    titleKey: $0.titleKey,
                    order: $0.order,
                    isCollapsed: $0.isCollapsed
                )
            }
    }

    func saveStartGroup(_ group: StartGroup) async {
        if let held = storedGroup(id: group.id) {
            held.title = group.title
            held.titleKey = group.titleKey
            held.order = group.order
            held.isCollapsed = group.isCollapsed
        } else {
            modelContext.insert(
                StoredStartGroup(
                    id: group.id,
                    title: group.title,
                    titleKey: group.titleKey,
                    order: group.order,
                    isCollapsed: group.isCollapsed
                )
            )
        }
        try? modelContext.save()
    }

    func deleteStartGroup(id: String) async {
        if let held = storedGroup(id: id) {
            modelContext.delete(held)
        }
        let members = (try? modelContext.fetch(
            FetchDescriptor<StoredStartGroupMembership>(predicate: #Predicate { $0.groupId == id })
        )) ?? []
        for member in members {
            modelContext.delete(member)
        }
        try? modelContext.save()
    }

    func startGroupMemberships() async -> [StartGroupMembership] {
        let stored = (try? modelContext.fetch(FetchDescriptor<StoredStartGroupMembership>())) ?? []

        return stored.map {
            StartGroupMembership(
                bundleIdentifier: $0.bundleIdentifier,
                groupId: $0.groupId,
                order: $0.order
            )
        }
    }

    func saveStartGroupMembership(_ membership: StartGroupMembership) async {
        if let held = storedMembership(bundleIdentifier: membership.bundleIdentifier) {
            held.groupId = membership.groupId
            held.order = membership.order
        } else {
            modelContext.insert(
                StoredStartGroupMembership(
                    bundleIdentifier: membership.bundleIdentifier,
                    groupId: membership.groupId,
                    order: membership.order
                )
            )
        }
        try? modelContext.save()
    }

    func clearStartGroupMembership(bundleIdentifier: String) async {
        guard let held = storedMembership(bundleIdentifier: bundleIdentifier) else { return }

        modelContext.delete(held)
        try? modelContext.save()
    }

    func applicationUsage() async -> [ApplicationUsage] {
        let stored = (try? modelContext.fetch(FetchDescriptor<StoredApplicationUsage>())) ?? []

        return stored.map {
            ApplicationUsage(
                bundleIdentifier: $0.bundleIdentifier,
                count: $0.count,
                lastLaunchedAt: $0.lastLaunchedAt
            )
        }
    }

    func recordLaunch(bundleIdentifier: String, at moment: Date) async {
        if let held = storedUsage(bundleIdentifier: bundleIdentifier) {
            held.count += 1
            held.lastLaunchedAt = moment
        } else {
            modelContext.insert(
                StoredApplicationUsage(
                    bundleIdentifier: bundleIdentifier,
                    count: 1,
                    lastLaunchedAt: moment
                )
            )
        }
        try? modelContext.save()
    }

    func quitExclusions() async -> [QuitExclusion] {
        let stored = (try? modelContext.fetch(FetchDescriptor<StoredQuitExclusion>())) ?? []

        return stored
            .sorted { $0.displayName < $1.displayName }
            .map { QuitExclusion(bundleIdentifier: $0.bundleIdentifier, displayName: $0.displayName) }
    }

    func exclude(_ exclusion: QuitExclusion) async {
        if let held = storedExclusion(bundleIdentifier: exclusion.bundleIdentifier) {
            held.displayName = exclusion.displayName
        } else {
            modelContext.insert(
                StoredQuitExclusion(
                    bundleIdentifier: exclusion.bundleIdentifier,
                    displayName: exclusion.displayName
                )
            )
        }
        try? modelContext.save()
    }

    func include(bundleIdentifier: String) async {
        guard let held = storedExclusion(bundleIdentifier: bundleIdentifier) else { return }

        modelContext.delete(held)
        try? modelContext.save()
    }

    private func storedExclusion(bundleIdentifier: String) -> StoredQuitExclusion? {
        var query = FetchDescriptor<StoredQuitExclusion>(
            predicate: #Predicate { $0.bundleIdentifier == bundleIdentifier }
        )
        query.fetchLimit = 1

        return try? modelContext.fetch(query).first
    }

    private func storedUsage(bundleIdentifier: String) -> StoredApplicationUsage? {
        var query = FetchDescriptor<StoredApplicationUsage>(
            predicate: #Predicate { $0.bundleIdentifier == bundleIdentifier }
        )
        query.fetchLimit = 1

        return try? modelContext.fetch(query).first
    }

    private func storedGroup(id: String) -> StoredStartGroup? {
        var query = FetchDescriptor<StoredStartGroup>(predicate: #Predicate { $0.id == id })
        query.fetchLimit = 1

        return try? modelContext.fetch(query).first
    }

    private func storedMembership(bundleIdentifier: String) -> StoredStartGroupMembership? {
        var query = FetchDescriptor<StoredStartGroupMembership>(
            predicate: #Predicate { $0.bundleIdentifier == bundleIdentifier }
        )
        query.fetchLimit = 1

        return try? modelContext.fetch(query).first
    }

    private func storedStartPin(bundleIdentifier: String) -> StoredStartPin? {
        var query = FetchDescriptor<StoredStartPin>(
            predicate: #Predicate { $0.bundleIdentifier == bundleIdentifier }
        )
        query.fetchLimit = 1

        return try? modelContext.fetch(query).first
    }

    private func preferences() -> StoredPreferences {
        var query = FetchDescriptor<StoredPreferences>()
        query.fetchLimit = 1

        if let held = try? modelContext.fetch(query).first {
            return held
        }
        let fresh = StoredPreferences(
            activePresetName: BarPresetCatalogue.default.name,
            hasCompletedOnboarding: false
        )
        modelContext.insert(fresh)

        return fresh
    }

    private func storedPreset(named name: String) -> StoredPreset? {
        var query = FetchDescriptor<StoredPreset>(predicate: #Predicate { $0.name == name })
        query.fetchLimit = 1

        return try? modelContext.fetch(query).first
    }

    private func storedSnapshot() -> StoredDockSnapshot? {
        var query = FetchDescriptor<StoredDockSnapshot>()
        query.fetchLimit = 1

        return try? modelContext.fetch(query).first
    }

    private func storedPin(bundleIdentifier: String) -> StoredPinnedApp? {
        var query = FetchDescriptor<StoredPinnedApp>(
            predicate: #Predicate { $0.bundleIdentifier == bundleIdentifier }
        )
        query.fetchLimit = 1

        return try? modelContext.fetch(query).first
    }

    private func decode(_ payload: Data) -> BarPreset? {
        try? JSONDecoder().decode(BarPreset.self, from: payload)
    }

    private func encode(_ preset: BarPreset) -> Data? {
        try? JSONEncoder().encode(preset)
    }
}
