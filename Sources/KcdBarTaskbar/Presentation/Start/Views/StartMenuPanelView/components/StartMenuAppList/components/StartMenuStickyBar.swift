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

package struct StartMenuStickyBar: View {
    package let titleKey: String
    package let glyph: String?
    package var isCollapsed = false
    package var onToggle: (() -> Void)?

    @State private var isHovered = false

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            if onToggle != nil {
                Image(systemName: StartMenuMetrics.disclosureGlyph)
                    .font(.system(size: StartMenuMetrics.disclosureSize, weight: .semibold))
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .rotationEffect(.degrees(isCollapsed ? 0 : 90))
            }
            if let glyph {
                Image(systemName: glyph)
                    .font(.system(size: StartMenuMetrics.disclosureSize, weight: .semibold))
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
            StartMenuSectionHeading(title: LocalizedStringKey(titleKey))
            Spacer(minLength: 0)
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.vertical, KbSpacing.s3)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear
        )
        .glassEffect(.regular.interactive(), in: Rectangle())
        .contentShape(Rectangle())
        .onTapGesture { onToggle?() }
        .onHover { isHovered = onToggle != nil && $0 }
        .animation(KbMotion.quick, value: isHovered)
        .animation(KbMotion.standard, value: isCollapsed)
    }
}
