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

package struct WifiNetworkRow: View {
    package let network: WifiNetwork

    @State private var isHovered = false

    package var body: some View {
        HStack(spacing: KbSpacing.s4) {
            Image(
                systemName: WifiStyle.symbol(for: network),
                variableValue: WifiStyle.level(for: network)
            )
                .font(.system(size: WifiMetrics.rowGlyphSize * KbControlCentreMetrics.glyphRatio))
                .foregroundStyle(network.isCurrent ? KbColors.onBrand : KbColors.onSurface)
                .frame(width: WifiMetrics.rowGlyphSize, height: WifiMetrics.rowGlyphSize)
                .background(Circle().fill(network.isCurrent ? KbColors.brand : KbColors.surfaceRaised))
            Text(network.ssid)
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: KbSpacing.s3)
            if network.isSecure {
                Image(systemName: WifiMetrics.lockSymbol)
                    .font(KbTypography.tileStatus)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
        }
        .padding(.horizontal, KbSpacing.s4)
        .frame(height: WifiMetrics.rowHeight)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: KbRadii.sm)
                .fill(isHovered ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity) : .clear)
        )
        .onHover { isHovered = $0 }
    }
}
