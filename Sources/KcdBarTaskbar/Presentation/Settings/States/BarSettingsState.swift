import Observation
import SwiftUI

/** The live preset the settings window edits, and the one the bar is drawn from. */
@MainActor
@Observable
package final class BarSettingsState {
    package private(set) var preset: BarPreset = BarPresetCatalogue.default
    package private(set) var presets: [BarPreset] = BarPresetCatalogue.all
    package private(set) var naming: BarPresetNamingRequest?

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
        await adoptStoredBuiltIns()
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
                self?.edit(edited)
            }
        )
    }

    package func isAcceptableName(_ name: String) -> Bool {
        guard let naming else { return false }

        return BarPresetNaming.isAcceptable(name, taken: takenNames(besides: naming.reason))
    }

    package func requestRename() {
        guard !BarPresetCatalogue.isBuiltIn(named: preset.name) else { return }

        naming = BarPresetNamingRequest(reason: .rename, proposed: preset.name)
    }

    package func commitNaming(_ name: String) async {
        guard let naming, BarPresetNaming.isAcceptable(name, taken: takenNames(besides: naming.reason)) else {
            return
        }
        let wanted = BarPresetNaming.trimmed(name)

        switch naming.reason {
        case .fork: await fork(as: wanted)
        case .rename: await rename(as: wanted)
        }
        self.naming = nil
    }

    package func cancelNaming() async {
        guard let naming else { return }

        self.naming = nil
        guard naming.reason == .fork else { return }

        await restoreStoredPreset()
    }

    private func edit(_ edited: BarPreset) {
        guard !BarPresetCatalogue.isBuiltIn(named: edited.name) else {
            preview(edited)
            return
        }
        apply(edited)
    }

    private func preview(_ edited: BarPreset) {
        preset = edited
        onChange(edited)

        guard naming == nil else { return }

        naming = BarPresetNamingRequest(
            reason: .fork,
            proposed: BarPresetNaming.copyName(of: edited.name, taken: takenNames(besides: .fork))
        )
    }

    private func apply(_ edited: BarPreset) {
        preset = edited
        presets = presets.map { $0.name == edited.name ? edited : $0 }
        onChange(edited)

        Task { [store] in await store.save(edited) }
    }

    private func fork(as name: String) async {
        var forked = preset
        forked.name = name

        await store.save(forked)
        await store.setActivePreset(named: name)
        presets = await store.presets()
        preset = forked
        onChange(forked)
    }

    private func rename(as name: String) async {
        let previous = preset.name
        var renamed = preset
        renamed.name = name

        await store.save(renamed)
        await store.setActivePreset(named: name)
        await store.remove(named: previous)
        presets = await store.presets()
        preset = renamed
        onChange(renamed)
    }

    private func adoptStoredBuiltIns() async {
        let drifted = presets.filter { held in
            guard let shipped = BarPresetCatalogue.all.first(where: { $0.name == held.name }) else {
                return false
            }
            return shipped != held
        }
        guard !drifted.isEmpty else { return }

        var taken = Set(presets.map(\.name))
        var activeName = preset.name

        for stored in drifted {
            var adopted = stored
            adopted.name = BarPresetNaming.copyName(of: stored.name, taken: taken)
            taken.insert(adopted.name)

            await store.save(adopted)
            await store.remove(named: stored.name)

            if stored.name == activeName {
                activeName = adopted.name
            }
        }
        await store.setActivePreset(named: activeName)
        presets = await store.presets()
        preset = presets.first { $0.name == activeName } ?? BarPresetCatalogue.default
    }

    private func restoreStoredPreset() async {
        let stored = await store.activePreset()

        presets = await store.presets()
        preset = stored
        onChange(stored)
    }

    private func takenNames(besides reason: BarPresetNamingReason) -> Set<String> {
        let names = Set(presets.map(\.name)).union(BarPresetCatalogue.all.map(\.name))

        guard reason == .rename else { return names }

        return names.subtracting([preset.name])
    }
}
