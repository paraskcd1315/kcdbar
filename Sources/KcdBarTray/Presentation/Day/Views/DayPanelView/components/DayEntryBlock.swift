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

package struct DayEntryBlock: View {
    package let block: DayBlock
    package let project: DayProject?
    package let now: Date
    package let height: CGFloat
    package let onOpen: (DayEntry) -> Void

    package init(
        block: DayBlock,
        project: DayProject?,
        now: Date,
        height: CGFloat,
        onOpen: @escaping (DayEntry) -> Void
    ) {
        self.block = block
        self.project = project
        self.now = now
        self.height = height
        self.onOpen = onOpen
    }

    package var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DayEntryBlockTitle(entry: block.entry, tone: tone)

            if height >= DayPanelMetrics.projectFloor, let project {
                Text(project.name)
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(tone)
                    .lineLimit(1)
            }

            if height >= DayPanelMetrics.rangeFloor {
                Text(DayFormatting.range(from: block.entry.startedAt, to: block.entry.endedAt(by: now)))
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(DayPanelMetrics.blockPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tone.opacity(DayPanelMetrics.blockTint), in: shape)
        .overlay {
            shape.strokeBorder(
                tone.opacity(DayPanelMetrics.blockEdge),
                lineWidth: DayPanelMetrics.ruleHeight
            )
        }
        .kbTappable(in: shape, perform: open)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DayPanelMetrics.blockRadius, style: .continuous)
    }

    private var tone: Color {
        project.flatMap { Color(hex: $0.colour) } ?? KbColors.onSurfaceMuted
    }

    private func open() {
        guard block.entry.opensATicket else { return }

        onOpen(block.entry)
    }
}
