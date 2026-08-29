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

package struct NetworkDetailRow: View {
    package let field: NetworkDetailField
    package let onCopy: () -> Void

    @State private var isHovered = false
    @State private var hasCopied = false

    package var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: KbSpacing.s4) {
            Text(LocalizedStringKey(field.titleKey))
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .frame(width: KbControlCentreMetrics.detailLabelWidth, alignment: .leading)
            Text(field.value)
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: hasCopied ? NetworkDetailKeys.copiedSymbol : NetworkDetailKeys.copySymbol)
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .opacity(isHovered || hasCopied ? 1 : 0)
                .kbTappable(in: Rectangle(), perform: copy)
        }
        .padding(.horizontal, KbSpacing.s4)
        .padding(.vertical, KbSpacing.s2)
        .background(
            RoundedRectangle(cornerRadius: KbRadii.sm)
                .fill(isHovered ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity) : .clear)
        )
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
        .animation(KbMotion.quick, value: hasCopied)
    }

    private func copy() {
        onCopy()
        hasCopied = true
        Task {
            try? await Task.sleep(for: .seconds(KbControlCentreMetrics.copiedDuration))
            hasCopied = false
        }
    }
}
