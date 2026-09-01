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

package struct TaskbarEntryBand: View {
    package let group: TaskbarEntryGroup
    package let preset: BarPreset
    package let isDragging: Bool
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onCloseWindow: (TaskbarEntryModel) -> Void
    package let onQuit: (TaskbarEntryModel) -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void
    package let onCycle: (TaskbarEntryModel) -> Void

    package var body: some View {
        KbAxisStack(isVertical: preset.edge.isVertical, spacing: TaskbarMetrics.bandSpacing) {
            ForEach(group.entries) { entry in
                TaskbarEntryView(
                    entry: entry,
                    preset: preset,
                    isDragging: isDragging,
                    onActivate: { onActivate(entry) },
                    onTogglePin: { onTogglePin(entry) },
                    onCloseWindow: { onCloseWindow(entry) },
                    onQuit: { onQuit(entry) },
                    onMiddleClick: { onMiddleClick(entry) },
                    onCycle: { onCycle(entry) }
                )
            }
        }
        .padding(alongBar, group.isBanded ? TaskbarMetrics.bandPadding : 0)
        .background {
            if group.isBanded {
                bandShape.fill(KbColors.bandFill)
            }
        }
    }

    private var alongBar: Edge.Set {
        preset.edge.isVertical ? .vertical : .horizontal
    }

    private var bandShape: AnyShape {
        KbBarShape.shape(
            edge: preset.edge,
            attachment: preset.attachment,
            cornerRadius: preset.entryCornerRadius
        )
    }
}
