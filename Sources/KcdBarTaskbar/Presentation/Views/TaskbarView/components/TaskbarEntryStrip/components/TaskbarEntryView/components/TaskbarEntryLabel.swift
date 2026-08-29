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

package struct TaskbarEntryLabel: View {
    package let entry: TaskbarEntryModel
    package let showsTitle: Bool
    package let iconSize: CGFloat
    package let isVertical: Bool
    package let side: CGFloat?
    package var stackSheets: Int = 0

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            TaskbarEntryIcon(icon: entry.icon, size: iconSize)
                .background {
                    if stackSheets > 0 {
                        TaskbarEntryStack(side: iconSize, sheets: stackSheets)
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    if entry.isFullScreen {
                        TaskbarEntryBadge(count: entry.fullScreenCount)
                            .padding(TaskbarMetrics.instanceDotInset)
                    }
                }
            if showsTitle {
                Text(entry.title)
                    .font(entry.isFrontmost ? KbTypography.entryTitleActive : KbTypography.entryTitle)
                    .foregroundStyle(entry.isMinimized ? KbColors.onSurfaceMuted : KbColors.onSurface)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .frame(maxWidth: showsTitle ? .infinity : nil, alignment: showsTitle ? .leading : .center)
        .frame(
            minWidth: showsTitle ? TaskbarMetrics.entryCompactWidth : nil,
            maxWidth: showsTitle ? TaskbarMetrics.entryMaxWidth : nil
        )
        .kbBarItem(isVertical: isVertical, side: showsTitle ? nil : side)
    }
}
