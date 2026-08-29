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

import KcdBarDesignSystem
import SwiftUI

package struct BatteryPanelHeader: View {
    package let state: BatteryState

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            HStack {
                Text("battery.title")
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(KbColors.onSurface)
                Spacer(minLength: KbSpacing.s5)
                Text("\(state.percentage)%")
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(BatteryTint.colour(for: BatteryStyle.tone(for: state)))
            }
            VStack(alignment: .leading, spacing: KbSpacing.s2) {
                Text(sourceKey)
                Text(statusKey)
                if let remaining = state.minutesRemaining {
                    Text(BatteryFormatting.remaining(minutes: remaining))
                }
            }
            .font(KbTypography.panelDetail)
            .foregroundStyle(KbColors.onSurfaceMuted)
        }
    }

    private var sourceKey: LocalizedStringKey {
        state.isPluggedIn ? "battery.source.adapter" : "battery.source.battery"
    }

    private var statusKey: LocalizedStringKey {
        switch BatteryStyle.status(for: state) {
        case .fullyCharged: "battery.status.charged"
        case .charging: "battery.status.charging"
        case .pluggedInNotCharging: "battery.status.notCharging"
        case .onBattery: state.isLowPower ? "battery.status.lowPower" : "battery.status.discharging"
        }
    }
}
