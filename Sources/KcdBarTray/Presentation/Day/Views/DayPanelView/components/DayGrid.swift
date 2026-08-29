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

package struct DayGrid: View {
    package let day: TrackerDay
    package let blocks: [DayBlock]
    package let now: Date
    package let showsNow: Bool
    package let onOpen: (DayEntry) -> Void

    package init(
        day: TrackerDay,
        blocks: [DayBlock],
        now: Date,
        showsNow: Bool,
        onOpen: @escaping (DayEntry) -> Void
    ) {
        self.day = day
        self.blocks = blocks
        self.now = now
        self.showsNow = showsNow
        self.onOpen = onOpen
    }

    package var body: some View {
        ScrollViewReader { rail in
            ScrollView(.vertical) {
                HStack(alignment: .top, spacing: DayPanelMetrics.blockGutter) {
                    DayHourRuler()

                    ZStack(alignment: .topLeading) {
                        DayHourLines()

                        ForEach(blocks) { block in
                            DayEntryBlock(
                                block: block,
                                project: day.project(of: block.entry),
                                now: now,
                                height: side(of: block),
                                onOpen: onOpen
                            )
                            .frame(width: width(of: block), height: side(of: block))
                            .offset(x: offset(of: block), y: top(of: block))
                        }

                        if showsNow {
                            DayNowLine()
                                .offset(y: nowOffset)
                        }
                    }
                    .frame(
                        width: DayPanelMetrics.blockArea,
                        height: DayPanelMetrics.gridHeight,
                        alignment: .topLeading
                    )
                }
            }
            .frame(height: DayPanelMetrics.gridMaxHeight)
            .onAppear { rail.scrollTo(landing, anchor: .top) }
        }
    }

    private var landing: Int {
        max(0, hourOfNow - DayPanelMetrics.nowLeadHours)
    }

    private var hourOfNow: Int {
        Int(fractionOfNow * Double(DayPanelMetrics.hoursInDay))
    }

    private var fractionOfNow: Double {
        min(max(now.timeIntervalSince(day.day) / DayLayout.dayLength, 0), 1)
    }

    private var nowOffset: CGFloat {
        DayPanelMetrics.gridHeight * CGFloat(fractionOfNow)
    }

    private func top(of block: DayBlock) -> CGFloat {
        DayPanelMetrics.gridHeight * CGFloat(block.top)
    }

    private func side(of block: DayBlock) -> CGFloat {
        max(
            DayPanelMetrics.blockMinHeight,
            DayPanelMetrics.gridHeight * CGFloat(block.height) - DayPanelMetrics.blockInset
        )
    }

    private func width(of block: DayBlock) -> CGFloat {
        DayPanelMetrics.blockArea / CGFloat(max(1, block.columns)) - DayPanelMetrics.blockInset
    }

    private func offset(of block: DayBlock) -> CGFloat {
        DayPanelMetrics.blockArea / CGFloat(max(1, block.columns)) * CGFloat(block.column)
    }
}
