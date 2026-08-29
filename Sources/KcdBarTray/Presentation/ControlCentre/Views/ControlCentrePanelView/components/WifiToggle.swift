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

package struct WifiToggle: View {
    package let isOn: Bool
    package let onToggle: (Bool) -> Void

    package var body: some View {
        Capsule()
            .fill(isOn ? KbColors.brand : KbColors.surfaceRaised)
            .frame(width: KbControlCentreMetrics.toggleWidth, height: KbControlCentreMetrics.toggleHeight)
            .overlay(alignment: isOn ? .trailing : .leading) {
                Circle()
                    .fill(KbColors.onBrand)
                    .padding(KbControlCentreMetrics.knobInset)
            }
            .kbTappable(in: Capsule()) { onToggle(!isOn) }
            .animation(KbMotion.quick, value: isOn)
    }
}
