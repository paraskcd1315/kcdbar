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

package struct TaskbarBatteryPill: View {
    package let state: BatteryState

    package var body: some View {
        HStack(spacing: BatteryMetrics.capGap) {
            ZStack {
                RoundedRectangle(cornerRadius: BatteryMetrics.pillRadius)
                    .stroke(KbColors.onSurfaceMuted, lineWidth: BatteryMetrics.pillBorderWidth)
                TaskbarBatteryFill(state: state)
                Text(percentage)
                    .font(KbTypography.batteryReadout)
                    .foregroundStyle(KbColors.surface)
                    .frame(width: BatteryMetrics.pillWidth, height: BatteryMetrics.pillHeight)
                    .mask(alignment: .leading) {
                        Rectangle()
                            .frame(width: BatteryStyle.filledWidth(for: state, in: BatteryMetrics.pillWidth))
                    }
                Text(percentage)
                    .font(KbTypography.batteryReadout)
                    .foregroundStyle(KbColors.onSurface)
                    .frame(width: BatteryMetrics.pillWidth, height: BatteryMetrics.pillHeight)
                    .mask(alignment: .trailing) {
                        Rectangle()
                            .frame(width: BatteryStyle.emptyWidth(for: state, in: BatteryMetrics.pillWidth))
                    }
            }
            .frame(width: BatteryMetrics.pillWidth, height: BatteryMetrics.pillHeight)
            RoundedRectangle(cornerRadius: BatteryMetrics.capWidth / 2)
                .fill(KbColors.onSurfaceMuted)
                .frame(width: BatteryMetrics.capWidth, height: BatteryMetrics.capHeight)
        }
    }

    private var percentage: String {
        "\(state.percentage)"
    }
}
