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

package struct WifiDisclosureRow: View {
    package let titleKey: LocalizedStringKey
    package let isExpanded: Bool
    package let onToggle: () -> Void

    @State private var isHovered = false

    package var body: some View {
        HStack {
            Text(titleKey)
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
            Spacer(minLength: KbSpacing.s3)
            Image(systemName: WifiMetrics.chevronSymbol)
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .rotationEffect(.degrees(isExpanded ? 90 : 0))
        }
        .padding(.horizontal, KbSpacing.s4)
        .frame(height: WifiMetrics.rowHeight)
        .background(
            RoundedRectangle(cornerRadius: KbRadii.sm)
                .fill(isHovered ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity) : .clear)
        )
        .onHover { isHovered = $0 }
        .kbTappable(in: Rectangle(), perform: onToggle)
    }
}
