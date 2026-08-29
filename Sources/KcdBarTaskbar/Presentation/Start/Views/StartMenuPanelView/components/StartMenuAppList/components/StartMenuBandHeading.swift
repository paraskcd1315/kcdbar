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

package struct StartMenuBandHeading: View {
    package let section: ApplicationSection
    package let isShowing: Bool
    package let onIndex: () -> Void

    @State private var isHovered = false

    package var body: some View {
        ZStack {
            if isShowing {
                HStack(spacing: 0) {
                    Group {
                        if let titleKey = section.titleKey {
                            Text(LocalizedStringKey(titleKey))
                        } else {
                            Text(section.key)
                        }
                    }
                    .font(KbTypography.panelDetail)
                    .foregroundStyle(isHovered ? KbColors.onSurface : KbColors.onSurfaceMuted)
                    .padding(.horizontal, KbSpacing.s3)
                    .padding(.vertical, KbSpacing.s2)
                    .background(
                        isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
                        in: shape
                    )
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, KbSpacing.s5)
                .padding(.top, KbSpacing.s3)
                .contentShape(Rectangle())
                .onTapGesture { if isIndexable { onIndex() } }
                .onHover { isHovered = isIndexable && $0 }
                .animation(KbMotion.quick, value: isHovered)
            }
        }
    }

    private var isIndexable: Bool {
        section.titleKey == nil
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.sm, style: .continuous)
    }
}
