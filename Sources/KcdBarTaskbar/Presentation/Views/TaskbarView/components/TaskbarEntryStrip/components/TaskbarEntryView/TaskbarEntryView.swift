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

package struct TaskbarEntryView: View {
    package let entry: TaskbarEntryModel
    package let preset: BarPreset
    package let isDragging: Bool
    package let onActivate: () -> Void
    package let onTogglePin: () -> Void
    package let onCloseWindow: () -> Void
    package let onQuit: () -> Void
    package let onMiddleClick: () -> Void

    @Environment(\.middleClickCatcher) private var middleClickCatcher
    @Environment(\.taskbarHover) private var hover

    @State private var isHovered = false
    @State private var frame: CGRect = .zero

    package var body: some View {
        TaskbarEntryLabel(
            entry: entry,
            showsTitle: TaskbarEntryStyle.showsTitle(
                content: preset.entryContent,
                isLauncher: entry.isLauncher
            ),
            iconSize: BarEntryMetrics.iconSize(for: preset),
            isVertical: preset.edge.isVertical,
            side: BarEntryMetrics.itemSide(for: preset),
            stackSheets: TaskbarEntryStyle.stackSheets(entry, grouping: preset.grouping)
        )
        .scaleEffect(
            TaskbarEntryStyle.magnification(sizing: preset.entrySizing, isHovered: isHovered),
            anchor: TaskbarEntryStyle.magnificationAnchor(edge: preset.edge)
        )
        .background {
            shape.fill(
                TaskbarEntryStyle.fill(
                    sizing: preset.entrySizing,
                    isFrontmost: entry.isFrontmost,
                    isHovered: isHovered
                )
            )
        }
        .overlay(alignment: .bottom) { TaskbarEntryIndicator(entry: entry) }
        .contentShape(shape)
        .overlay { middleClickCatcher(onMiddleClick) }
        .onTapGesture(perform: onActivate)
        .opacity(isDragging ? TaskbarMetrics.draggingOpacity : 1)
        .animation(KbMotion.quick, value: isHovered)
        .animation(KbMotion.quick, value: entry.isFrontmost)
        .animation(KbMotion.quick, value: isDragging)
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .named(TaskbarBarLayout.coordinateSpace))
        } action: { frame = $0 }
        .onHover { isHovered = $0 }
        .task(id: isHovered) { await revealTooltip() }
        .onDisappear { hover?.leave(entry) }
        .contextMenu {
            if entry.bundleIdentifier != nil {
                TaskbarEntryMenu(
                    entry: entry,
                    onTogglePin: onTogglePin,
                    onCloseWindow: onCloseWindow,
                    onQuit: onQuit
                )
            }
        }
    }

    private var shape: AnyShape {
        TaskbarEntryStyle.shape(
            isOpenHere: TaskbarEntryStyle.isOpenHere(entry),
            cornerRadius: preset.entryCornerRadius
        )
    }

    private func revealTooltip() async {
        guard isHovered, !isDragging, !entry.applicationName.isEmpty || !entry.title.isEmpty else {
            hover?.leave(entry)
            return
        }
        if hover?.isShowing(entry) != true {
            try? await Task.sleep(for: TaskbarMetrics.tooltipDelay)
        }
        guard !Task.isCancelled else { return }

        hover?.enter(entry, at: frame)
    }
}
