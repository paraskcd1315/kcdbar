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

package struct BatteryPanelEnergyList: View {
    package let users: [EnergyUser]

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            Text("battery.energy.heading")
                .font(KbTypography.panelDetail)
                .foregroundStyle(KbColors.onSurfaceMuted)
            VStack(alignment: .leading, spacing: KbSpacing.s2) {
                ForEach(users) { user in
                    Text(user.name)
                        .font(KbTypography.panelItem)
                        .foregroundStyle(KbColors.onSurface)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
    }
}
