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

package struct TaskbarPreviewClose: View {
    package let onClose: () -> Void

    @State private var isHovered = false

    package var body: some View {
        Image(systemName: TaskbarMetrics.previewCloseSymbol)
            .font(.system(size: TaskbarMetrics.previewCloseGlyph, weight: .bold))
            .foregroundStyle(KbColors.onSurface)
            .frame(width: TaskbarMetrics.previewCloseSide, height: TaskbarMetrics.previewCloseSide)
            .background(isHovered ? KbColors.batteryCritical : KbColors.focusedFill, in: .circle)
            .overlay {
                Circle().strokeBorder(KbColors.separator, lineWidth: TaskbarMetrics.separatorThickness)
            }
            .contentShape(.circle)
            .onHover { isHovered = $0 }
            .onTapGesture(perform: onClose)
            .animation(KbMotion.quick, value: isHovered)
    }
}
