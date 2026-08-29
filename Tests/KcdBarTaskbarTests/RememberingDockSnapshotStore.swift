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

actor RememberingDockSnapshotStore: DockSnapshotStorePort {
    private var held: DockSettingsSnapshot?
    private(set) var clears = 0

    init(held: DockSettingsSnapshot? = nil) {
        self.held = held
    }

    func snapshot() async -> DockSettingsSnapshot? {
        held
    }

    func remember(_ snapshot: DockSettingsSnapshot) async {
        held = snapshot
    }

    func clear() async {
        held = nil
        clears += 1
    }
}
