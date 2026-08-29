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

package struct StartMenuGroupKebab: View {
    package let onRename: () -> Void
    package let onRemove: () -> Void

    @State private var isHovered = false

    package var body: some View {
        Menu {
            Button("start.group.rename", action: onRename)
            Button("start.group.remove", role: .destructive, action: onRemove)
        } label: {
            Image(systemName: StartMenuMetrics.kebabGlyph)
                .font(.system(size: StartMenuMetrics.powerGlyphSize, weight: .semibold))
                .foregroundStyle(KbColors.onSurfaceMuted)
                .frame(
                    width: StartMenuMetrics.powerButtonSize,
                    height: StartMenuMetrics.powerButtonSize
                )
                .background(
                    isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
                    in: Circle()
                )
                .contentShape(Circle())
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .fixedSize()
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }
}
