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

package struct TaskbarStartButton: View {
    package let mark: BarStartMark
    package let iconSize: CGFloat
    package let cornerRadius: CGFloat
    package let isVertical: Bool
    package let side: CGFloat
    package let onOpen: () -> Void
    package let onOpenSettings: () -> Void
    package let onOpenAbout: () -> Void

    @State private var isHovered = false

    package var body: some View {
        Button(action: onOpen) {
            TaskbarStartMarkView(mark: mark, size: iconSize)
                .foregroundStyle(KbColors.onSurface)
                .frame(width: iconSize, height: iconSize)
                .kbBarItem(isVertical: isVertical, side: side)
                .contentShape(.rect(cornerRadius: cornerRadius))
        }
        .buttonStyle(.plain)
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: .rect(cornerRadius: cornerRadius))
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
        .contextMenu {
            Button("taskbar.menu.settings", action: onOpenSettings)
            Divider()
            Button("taskbar.menu.about", action: onOpenAbout)
        }
    }
}
