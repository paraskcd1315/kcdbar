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

package struct StartMenuAppRow: View {
    package let application: InstalledApplication
    package let icon: Image?
    package let isPinned: Bool
    package let onLaunch: () -> Void
    package let onTogglePin: () -> Void

    @State private var isHovered = false

    package var body: some View {
        HStack(spacing: KbSpacing.s4) {
            StartMenuAppIcon(icon: icon, size: StartMenuMetrics.rowIconSize)
            Text(application.displayName)
                .font(KbTypography.menuItem)
                .foregroundStyle(KbColors.onSurface)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, KbSpacing.s4)
        .padding(.vertical, KbSpacing.s3)
        .background(
            isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
            in: shape
        )
        .kbTappable(in: shape, perform: onLaunch)
        .contextMenu {
            Button(isPinned ? "start.unpin" : "start.pin", action: onTogglePin)
        }
        .padding(.horizontal, KbSpacing.s5)
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.sm, style: .continuous)
    }
}
