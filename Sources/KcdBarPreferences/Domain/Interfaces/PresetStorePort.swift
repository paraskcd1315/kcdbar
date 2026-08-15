protocol PresetStorePort: Sendable {
    func presets() async -> [BarPreset]
    func save(_ preset: BarPreset) async
    func remove(named name: String) async
    func activePreset() async -> BarPreset
    func setActivePreset(named name: String) async
}
