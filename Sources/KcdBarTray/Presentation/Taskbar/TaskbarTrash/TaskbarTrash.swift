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

package struct TaskbarTrash: View {
    package let monitor: TrashMonitor
    package let iconSize: CGFloat
    package let isVertical: Bool
    package let side: CGFloat

    @State private var isHovered = false

    package init(
        monitor: TrashMonitor,
        iconSize: CGFloat = TrashMetrics.iconSize,
        isVertical: Bool = false,
        side: CGFloat = TrashMetrics.iconSize + TrashMetrics.glyphInset * 2
    ) {
        self.monitor = monitor
        self.iconSize = iconSize
        self.isVertical = isVertical
        self.side = side
    }

    package var body: some View {
        Group {
            if let icon = monitor.icon {
                icon
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: TrashSymbols.fallback(isEmpty: monitor.state.isEmpty))
                    .foregroundStyle(KbColors.onSurface)
            }
        }
        .frame(width: iconSize, height: iconSize)
        .kbBarItem(isVertical: isVertical, side: side)
        .kbTappable(in: shape) { monitor.open() }
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: shape)
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
        .contextMenu {
            TaskbarTrashMenu(
                isEmpty: monitor.state.isEmpty,
                onOpen: { monitor.open() },
                onEmpty: { monitor.empty() }
            )
        }
    }

    private var shape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.sm))
    }
}
