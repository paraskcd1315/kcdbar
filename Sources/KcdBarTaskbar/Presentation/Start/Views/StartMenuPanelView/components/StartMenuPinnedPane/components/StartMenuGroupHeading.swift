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

package struct StartMenuGroupHeading: View {
    package let group: StartGroup
    package let isEditing: Bool
    package let onToggle: () -> Void
    package let onRename: () -> Void
    package let onCommit: (String) -> Void
    package let onRemove: () -> Void

    @State private var draft = ""
    @FocusState private var isFocused: Bool

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            Image(systemName: StartMenuMetrics.disclosureGlyph)
                .font(.system(size: StartMenuMetrics.disclosureSize, weight: .semibold))
                .foregroundStyle(KbColors.onSurfaceMuted)
                .rotationEffect(.degrees(group.isCollapsed ? 0 : 90))
            if isEditing {
                TextField("start.group.name", text: $draft)
                    .textFieldStyle(.plain)
                    .font(KbTypography.panelDetail)
                    .foregroundStyle(KbColors.onSurface)
                    .focused($isFocused)
                    .onSubmit { onCommit(draft) }
                    .onAppear {
                        draft = group.title ?? ""
                        isFocused = true
                    }
            } else {
                StartMenuGroupTitle(group: group)
            }
            Spacer(minLength: 0)
            StartMenuGroupKebab(onRename: onRename, onRemove: onRemove)
        }
        .padding(.horizontal, KbSpacing.s6)
        .contentShape(Rectangle())
        .onTapGesture { if !isEditing { onToggle() } }
        .animation(KbMotion.quick, value: group.isCollapsed)
    }
}
