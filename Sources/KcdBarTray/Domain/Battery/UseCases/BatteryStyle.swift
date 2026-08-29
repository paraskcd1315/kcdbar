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

import CoreGraphics

package enum BatteryStyle {
    package static func tone(for state: BatteryState) -> BatteryTone {
        if state.isLowPower { return .powerSave }
        if state.percentage <= BatteryMetrics.criticalPercentage { return .critical }
        if state.percentage <= BatteryMetrics.warningPercentage { return .warning }
        if state.isCharging || state.isCharged { return .full }

        return .neutral
    }

    package static func status(for state: BatteryState) -> BatteryStatus {
        if state.isCharged { return .fullyCharged }
        if state.isCharging { return .charging }
        if state.isPluggedIn { return .pluggedInNotCharging }

        return .onBattery
    }

    package static func fill(for state: BatteryState) -> CGFloat {
        let fraction = CGFloat(state.percentage) / CGFloat(BatteryMetrics.fullPercentage)

        return max(BatteryMetrics.minimumFill, min(1, fraction))
    }

    package static func filledWidth(for state: BatteryState, in width: CGFloat) -> CGFloat {
        width * fill(for: state)
    }

    package static func emptyWidth(for state: BatteryState, in width: CGFloat) -> CGFloat {
        width * (1 - fill(for: state))
    }

    package static func significant(_ users: [EnergyUser]) -> [EnergyUser] {
        users
            .filter { $0.impact >= BatteryMetrics.significantEnergyImpact }
            .sorted { $0.impact > $1.impact }
            .prefix(BatteryMetrics.significantEnergyLimit)
            .map { $0 }
    }
}
