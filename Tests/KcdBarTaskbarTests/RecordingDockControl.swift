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

final class RecordingDockControl: DockControlPort, @unchecked Sendable {
    private(set) var written: [[DockDefault]] = []
    private(set) var restarts = 0

    let held: DockSettingsSnapshot

    init(held: DockSettingsSnapshot) {
        self.held = held
    }

    func settings() -> DockSettingsSnapshot {
        held
    }

    func write(_ defaults: [DockDefault]) {
        guard !defaults.isEmpty else { return }

        written.append(defaults)
    }

    func restart() {
        restarts += 1
    }
}
