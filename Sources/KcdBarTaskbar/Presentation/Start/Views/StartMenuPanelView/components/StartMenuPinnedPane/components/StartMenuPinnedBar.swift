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

package struct StartMenuPinnedBar: View {
    package let isEditing: Bool
    package let showsRemove: Bool
    package let onAdd: () -> Void
    package let onRemove: () -> Void
    package let onCancel: () -> Void

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            Spacer(minLength: 0)
            if isEditing {
                if showsRemove {
                    StartMenuHeaderButton(
                        glyph: StartMenuMetrics.trashGlyph,
                        titleKey: "start.group.remove",
                        isDestructive: true,
                        action: onRemove
                    )
                }
                StartMenuHeaderButton(
                    glyph: StartMenuMetrics.cancelGlyph,
                    titleKey: "start.group.cancel",
                    action: onCancel
                )
            } else {
                StartMenuHeaderButton(
                    glyph: StartMenuMetrics.addGlyph,
                    titleKey: "start.group.add",
                    action: onAdd
                )
            }
        }
        .padding(.horizontal, KbSpacing.s5)
        .padding(.vertical, KbSpacing.s4)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .animation(KbMotion.quick, value: isEditing)
        .animation(KbMotion.quick, value: showsRemove)
    }
}
