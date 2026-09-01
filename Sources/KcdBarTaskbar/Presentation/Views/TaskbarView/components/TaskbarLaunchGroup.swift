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

package struct TaskbarLaunchGroup: View {
    package let viewModel: TaskbarViewModel
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onOpenStart: () -> Void
    package let onOpenSettings: () -> Void
    package let onOpenAbout: () -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onCloseWindow: (TaskbarEntryModel) -> Void
    package let onQuit: (TaskbarEntryModel) -> Void
    package let onDropPin: (String, TaskbarEntryModel) -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void
    package let onCycle: (TaskbarEntryModel) -> Void

    package var body: some View {
        KbAxisStack(isVertical: viewModel.preset.edge.isVertical, spacing: viewModel.preset.entrySpacing) {
            if viewModel.preset.startButton == .centered {
                TaskbarStartButton(
                    mark: viewModel.preset.startMark,
                    iconSize: BarEntryMetrics.iconSize(for: viewModel.preset),
                    cornerRadius: viewModel.preset.entryCornerRadius,
                    isVertical: viewModel.preset.edge.isVertical,
                    side: BarEntryMetrics.itemSide(for: viewModel.preset),
                    onOpen: onOpenStart,
                    onOpenSettings: onOpenSettings,
                    onOpenAbout: onOpenAbout
                )
            }
            TaskbarEntryStrip(
                entries: viewModel.entries,
                preset: viewModel.preset,
                onActivate: onActivate,
                onTogglePin: onTogglePin,
                onCloseWindow: onCloseWindow,
                onQuit: onQuit,
                onDropPin: onDropPin,
                onMiddleClick: onMiddleClick,
                onCycle: onCycle
            )
        }
        .frame(
            maxWidth: TaskbarStripLayout.expandsAlongBar(preset: viewModel.preset)
                && !viewModel.preset.edge.isVertical ? .infinity : nil,
            maxHeight: TaskbarStripLayout.expandsAlongBar(preset: viewModel.preset)
                && viewModel.preset.edge.isVertical ? .infinity : nil,
            alignment: TaskbarStripLayout.alignment(preset: viewModel.preset)
        )
    }
}
