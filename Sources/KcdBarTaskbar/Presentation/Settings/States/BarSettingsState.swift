import Observation
import SwiftUI

/** The live preset the settings window edits, and the one the bar is drawn from. */
@MainActor
@Observable
package final class BarSettingsState {
    package private(set) var preset: BarPreset = BarPresetCatalogue.default
    package private(set) var presets: [BarPreset] = BarPresetCatalogue.all

    private let store: any PresetStorePort
    private var onChange: (BarPreset) -> Void = { _ in }

    package init(store: any PresetStorePort) {
        self.store = store
    }

    package func observe(_ onChange: @escaping (BarPreset) -> Void) {
        self.onChange = onChange
    }

    package func load() async {
        presets = await store.presets()
        preset = await store.activePreset()
        onChange(preset)
    }

    package func select(presetNamed name: String) async {
        guard let wanted = presets.first(where: { $0.name == name }) else { return }

        preset = wanted
        await store.setActivePreset(named: name)
        onChange(wanted)
    }

    package func binding<Value>(_ keyPath: WritableKeyPath<BarPreset, Value>) -> Binding<Value> {
        Binding(
            get: { [weak self] in
                self?.preset[keyPath: keyPath] ?? BarPresetCatalogue.default[keyPath: keyPath]
            },
            set: { [weak self] value in
                guard var edited = self?.preset else { return }

                edited[keyPath: keyPath] = value
                self?.apply(edited)
            }
        )
    }

    private func apply(_ edited: BarPreset) {
        preset = edited
        presets = presets.map { $0.name == edited.name ? edited : $0 }
        onChange(edited)

        Task { [store] in await store.save(edited) }
    }
}
