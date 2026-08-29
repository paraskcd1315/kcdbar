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

package struct ControlCentreDetailHeader: View {
    package let titleKey: LocalizedStringKey
    package let isOn: Bool
    package let onBack: () -> Void
    package let onSetPower: (Bool) -> Void

    @State private var isHovered = false

    package var body: some View {
        HStack(spacing: KbSpacing.s5) {
            HStack(spacing: KbSpacing.s3) {
                Image(systemName: KbControlCentreMetrics.backSymbol)
                    .font(KbTypography.tileStatus)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                Text(titleKey)
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(KbColors.onSurface)
            }
            .padding(.horizontal, KbSpacing.s3)
            .padding(.vertical, KbSpacing.s2)
            .background(
                RoundedRectangle(cornerRadius: KbRadii.md, style: .continuous)
                    .fill(
                        isHovered
                            ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity)
                            : .clear
                    )
            )
            .kbTappable(in: Rectangle(), perform: onBack)
            .onHover { isHovered = $0 }
            Spacer(minLength: KbSpacing.s5)
            WifiToggle(isOn: isOn, onToggle: onSetPower)
        }
    }
}
