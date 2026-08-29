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
