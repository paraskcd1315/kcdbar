import Foundation

@testable import KcdBarTaskbar

actor RecordingPresetStore: PresetStorePort {
    private var saved: [String: BarPreset]
    private var activeName: String

    init(saved: [BarPreset] = [], activeName: String = BarPresetCatalogue.default.name) {
        self.saved = Dictionary(uniqueKeysWithValues: saved.map { ($0.name, $0) })
        self.activeName = activeName
    }

    func presets() async -> [BarPreset] {
        let held = Array(saved.values).sorted { $0.name < $1.name }
        let names = Set(held.map(\.name))

        return BarPresetCatalogue.all.filter { !names.contains($0.name) } + held
    }

    func save(_ preset: BarPreset) async {
        saved[preset.name] = preset
    }

    func remove(named name: String) async {
        saved.removeValue(forKey: name)
    }

    func activePreset() async -> BarPreset {
        await presets().first { $0.name == activeName } ?? BarPresetCatalogue.default
    }

    func setActivePreset(named name: String) async {
        activeName = name
    }

    func storedNames() async -> Set<String> {
        Set(saved.keys)
    }

    func stored(named name: String) async -> BarPreset? {
        saved[name]
    }

    func active() async -> String {
        activeName
    }
}
