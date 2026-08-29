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

package struct StartMenuHeaderButton: View {
    package let glyph: String
    package let titleKey: LocalizedStringKey
    package let isDestructive: Bool
    package let action: () -> Void

    @State private var isHovered = false

    package init(
        glyph: String,
        titleKey: LocalizedStringKey,
        isDestructive: Bool = false,
        action: @escaping () -> Void
    ) {
        self.glyph = glyph
        self.titleKey = titleKey
        self.isDestructive = isDestructive
        self.action = action
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s2) {
            Image(systemName: glyph)
                .font(.system(size: StartMenuMetrics.powerGlyphSize, weight: .semibold))
            Text(titleKey)
                .font(KbTypography.entryTitle)
        }
        .foregroundStyle(isDestructive ? KbColors.batteryCritical : KbColors.onSurface)
        .padding(.horizontal, KbSpacing.s4)
        .frame(height: StartMenuMetrics.powerButtonSize)
        .glassEffect(.regular.interactive(), in: Capsule())
        .overlay(Capsule().stroke(KbColors.separator, lineWidth: KbEdgeMetrics.width))
        .background(
            isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
            in: Capsule()
        )
        .kbTappable(in: Capsule(), perform: action)
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }
}
