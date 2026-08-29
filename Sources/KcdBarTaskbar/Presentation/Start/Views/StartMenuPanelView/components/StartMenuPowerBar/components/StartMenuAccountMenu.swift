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

package struct StartMenuAccountMenu: View {
    package let userName: String
    package let avatar: Image?
    package let onPower: (StartPowerAction) -> Void

    @State private var isHovered = false

    package var body: some View {
        Menu {
            ForEach(StartPowerAction.accountActions) { action in
                Button {
                    onPower(action)
                } label: {
                    Label(LocalizedStringKey(action.titleKey), systemImage: action.symbol)
                }
            }
        } label: {
            HStack(spacing: KbSpacing.s3) {
                StartMenuAvatar(image: avatar)
                Text(userName)
                    .font(KbTypography.menuItem)
                    .foregroundStyle(KbColors.onSurface)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.horizontal, KbSpacing.s3)
            .padding(.vertical, KbSpacing.s2)
            .background(
                isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
                in: shape
            )
            .contentShape(shape)
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .frame(height: StartMenuMetrics.powerButtonSize)
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.md, style: .continuous)
    }
}
