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

import Testing

@testable import KcdBarTaskbar

@MainActor
struct BarSettingsForkTests {
    @Test func editingAShippedPresetAsksBeforeItChangesAnything() async {
        let store = RecordingPresetStore()
        let settings = BarSettingsState(store: store)
        await settings.load()

        settings.binding(\.iconSize).wrappedValue = 48

        #expect(settings.naming?.reason == .fork)
        #expect(await store.storedNames().isEmpty)
        #expect(settings.preset.iconSize == 48)
    }

    @Test func confirmingKeepsTheChangeAsANewPresetAndLeavesTheShippedOneAlone() async {
        let store = RecordingPresetStore()
        let settings = BarSettingsState(store: store)
        await settings.load()

        settings.binding(\.iconSize).wrappedValue = 48
        await settings.commitNaming("Mine")

        #expect(settings.naming == nil)
        #expect(settings.preset.name == "Mine")
        #expect(await store.active() == "Mine")
        #expect(await store.stored(named: "Mine")?.iconSize == 48)
        #expect(await store.stored(named: BarPresetCatalogue.windows11.name) == nil)
        #expect(settings.presets.contains { $0 == BarPresetCatalogue.windows11 })
    }

    @Test func cancellingPutsTheShippedPresetBack() async {
        let store = RecordingPresetStore()
        let settings = BarSettingsState(store: store)
        await settings.load()

        settings.binding(\.iconSize).wrappedValue = 48
        await settings.cancelNaming()

        #expect(settings.naming == nil)
        #expect(settings.preset == BarPresetCatalogue.windows11)
        #expect(await store.storedNames().isEmpty)
    }

    @Test func aCustomPresetIsEditedInPlaceWithNoQuestionAsked() async {
        var mine = BarPresetCatalogue.windows11
        mine.name = "Mine"
        let store = RecordingPresetStore(saved: [mine], activeName: "Mine")
        let settings = BarSettingsState(store: store)
        await settings.load()

        settings.binding(\.iconSize).wrappedValue = 20

        #expect(settings.naming == nil)
        #expect(settings.preset.iconSize == 20)
    }

    @Test func renamingMovesTheStoredPresetAndTheActiveSelectionWithIt() async {
        var mine = BarPresetCatalogue.dock
        mine.name = "Mine"
        let store = RecordingPresetStore(saved: [mine], activeName: "Mine")
        let settings = BarSettingsState(store: store)
        await settings.load()

        settings.requestRename()
        #expect(settings.naming?.reason == .rename)

        await settings.commitNaming("Yours")

        #expect(settings.preset.name == "Yours")
        #expect(await store.active() == "Yours")
        #expect(await store.stored(named: "Mine") == nil)
        #expect(settings.presets.contains { $0.name == "Yours" })
    }

    @Test func aShippedPresetCannotBeRenamed() async {
        let store = RecordingPresetStore()
        let settings = BarSettingsState(store: store)
        await settings.load()

        settings.requestRename()

        #expect(settings.naming == nil)
    }

    @Test func aNameAlreadyTakenIsRefused() async {
        let store = RecordingPresetStore()
        let settings = BarSettingsState(store: store)
        await settings.load()

        settings.binding(\.iconSize).wrappedValue = 48

        #expect(!settings.isAcceptableName(BarPresetCatalogue.dock.name))
        #expect(!settings.isAcceptableName("   "))
        #expect(settings.isAcceptableName("Mine"))
    }

    @Test func aShippedPresetAlreadyEditedByAnEarlierBuildIsAdoptedAsACustomOne() async {
        var drifted = BarPresetCatalogue.windows11
        drifted.iconSize = 52
        let store = RecordingPresetStore(saved: [drifted], activeName: drifted.name)
        let settings = BarSettingsState(store: store)

        await settings.load()

        let adopted = BarPresetNaming.copyName(of: BarPresetCatalogue.windows11.name, taken: [])
        #expect(settings.preset.name == adopted)
        #expect(settings.preset.iconSize == 52)
        #expect(await store.active() == adopted)
        #expect(await store.stored(named: BarPresetCatalogue.windows11.name) == nil)
        #expect(settings.presets.contains { $0 == BarPresetCatalogue.windows11 })
    }
}
