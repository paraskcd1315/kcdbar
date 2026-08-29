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

package struct StartMenuPowerButton: View {
    package let action: StartPowerAction
    package let onPower: () -> Void

    @State private var isHovered = false

    package var body: some View {
        Image(systemName: action.symbol)
            .font(.system(size: StartMenuMetrics.powerGlyphSize, weight: .medium))
            .foregroundStyle(KbColors.onSurface)
            .frame(
                width: StartMenuMetrics.powerButtonSize,
                height: StartMenuMetrics.powerButtonSize
            )
            .background(
                isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
                in: shape
            )
            .kbTappable(in: shape, perform: onPower)
            .help(Text(LocalizedStringKey(action.titleKey)))
            .onHover { isHovered = $0 }
            .animation(KbMotion.quick, value: isHovered)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.sm, style: .continuous)
    }
}
