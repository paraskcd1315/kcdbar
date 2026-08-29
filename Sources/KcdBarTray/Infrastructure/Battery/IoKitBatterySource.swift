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
import IOKit.ps

package struct IoKitBatterySource: BatteryPort {
    package init() {}

    package func state() -> BatteryState {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef]
        else {
            return .absent
        }

        for source in sources {
            guard let description = IOPSGetPowerSourceDescription(snapshot, source)?
                .takeUnretainedValue() as? [String: Any],
                description[kIOPSIsPresentKey] as? Bool == true,
                let capacity = description[kIOPSCurrentCapacityKey] as? Int,
                let maximum = description[kIOPSMaxCapacityKey] as? Int,
                maximum > 0
            else {
                continue
            }

            let isCharging = description[kIOPSIsChargingKey] as? Bool ?? false
            let onAdapter = description[kIOPSPowerSourceStateKey] as? String == kIOPSACPowerValue

            return BatteryState(
                isPresent: true,
                percentage: BatteryPercentage.of(capacity: capacity, maximum: maximum),
                isCharging: isCharging,
                isCharged: description[kIOPSIsChargedKey] as? Bool ?? false,
                isPluggedIn: onAdapter,
                isLowPower: ProcessInfo.processInfo.isLowPowerModeEnabled,
                minutesRemaining: remaining(from: description, isCharging: isCharging)
            )
        }

        return .absent
    }

    package func energyUsers() async -> [EnergyUser] {
        await TopEnergySampler.sample()
    }

    private func remaining(from description: [String: Any], isCharging: Bool) -> Int? {
        let key = isCharging ? kIOPSTimeToFullChargeKey : kIOPSTimeToEmptyKey
        guard let minutes = description[key] as? Int, minutes > 0 else { return nil }

        return minutes
    }
}
