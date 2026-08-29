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

package struct TaskbarShowDesktopButton: View {
    package let isShowingDesktop: Bool
    package let shape: AnyShape
    package let onToggle: () -> Void

    @State private var isHovered = false

    package var body: some View {
        Rectangle()
            .fill(.clear)
            .frame(width: TaskbarMetrics.showDesktopWidth)
            .frame(maxHeight: .infinity)
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(KbColors.separator)
                    .frame(width: TaskbarMetrics.showDesktopDividerWidth)
            }
            .background(shape.fill(fill))
            .kbTappable(in: shape, perform: onToggle)
            .animation(KbMotion.quick, value: isHovered)
            .animation(KbMotion.quick, value: isShowingDesktop)
            .onHover { isHovered = $0 }
    }

    private var fill: Color {
        if isShowingDesktop {
            return KbColors.onSurface.opacity(TaskbarMetrics.showDesktopActiveOpacity)
        }

        return isHovered
            ? KbColors.onSurface.opacity(TaskbarMetrics.showDesktopHoverOpacity)
            : .clear
    }
}
