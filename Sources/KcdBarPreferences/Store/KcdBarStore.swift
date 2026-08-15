import Foundation
import KcdBarTaskbar
import SwiftData

/** Everything KCDBar remembers between launches. */
@ModelActor
actor KcdBarStore: PresetStorePort, DockSnapshotStorePort, PinnedAppStorePort {
    package static let fileName = "kcdbar.store"

    static func container(at url: URL? = nil, inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            StoredPreset.self,
            StoredDockSnapshot.self,
            StoredPreferences.self,
            StoredPinnedApp.self
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
