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

package struct StartMenuSearchField: View {
    package let onOpen: () -> Void

    package init(onOpen: @escaping () -> Void) {
        self.onOpen = onOpen
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s4) {
            Image(systemName: StartMenuMetrics.searchGlyph)
                .font(KbTypography.menuItem)
                .foregroundStyle(KbColors.onSurfaceMuted)
            Text("start.search.spotlight")
                .font(KbTypography.menuItem)
                .foregroundStyle(KbColors.onSurfaceMuted)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, KbSpacing.s4)
        .padding(.vertical, KbSpacing.s3)
        .glassEffect(.regular.interactive(), in: shape)
        .overlay(shape.stroke(KbColors.separator, lineWidth: KbEdgeMetrics.width))
        .kbTappable(in: shape, perform: onOpen)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.md, style: .continuous)
    }
}
