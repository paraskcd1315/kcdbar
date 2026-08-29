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
import Observation

/** The bar's live view of the power source. */
@MainActor
@Observable
package final class BatteryMonitor {
    package private(set) var state: BatteryState = .absent
    package private(set) var energyUsers: [EnergyUser] = []
    package private(set) var isSamplingEnergy = false

    private let source: any BatteryPort
    private var sampledAt: Date?

    package var hasSampledEnergy: Bool {
        sampledAt != nil
    }

    package init(source: any BatteryPort) {
        self.source = source
    }

    package func refresh() {
        state = source.state()
    }

    package func sampleEnergy(now: Date = Date()) async {
        if let sampledAt, now.timeIntervalSince(sampledAt) < BatteryMetrics.sampleInterval {
            return
        }
        sampledAt = now
        isSamplingEnergy = true
        energyUsers = BatteryStyle.significant(await source.energyUsers())
        isSamplingEnergy = false
    }
}
