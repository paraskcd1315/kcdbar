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

package struct BatteryPanelSurface: View {
    package let state: BatteryState
    package let energyUsers: [EnergyUser]
    package let isSampling: Bool
    package let arrowX: CGFloat

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s5) {
            BatteryPanelHeader(state: state)
            if isSampling || !energyUsers.isEmpty {
                Rectangle()
                    .fill(KbColors.separator)
                    .frame(height: KbPopoverMetrics.dividerHeight)
                if isSampling {
                    BatteryPanelEnergySkeleton()
                } else {
                    BatteryPanelEnergyList(users: energyUsers)
                }
            }
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.top, KbSpacing.s6)
        .padding(.bottom, KbSpacing.s6 + KbPopoverMetrics.arrowSize.height)
        .frame(width: BatteryMetrics.panelWidth, alignment: .leading)
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: arrowX))
        .overlay { KbPopoverEdge(arrowX: arrowX) }
        .animation(KbMotion.standard, value: isSampling)
    }
}
