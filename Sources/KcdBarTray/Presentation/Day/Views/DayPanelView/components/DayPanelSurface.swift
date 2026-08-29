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

package struct DayPanelSurface: View {
    package let day: TrackerDay?
    package let arrowX: CGFloat
    package let onOpen: (DayEntry) -> Void

    package init(day: TrackerDay?, arrowX: CGFloat, onOpen: @escaping (DayEntry) -> Void) {
        self.day = day
        self.arrowX = arrowX
        self.onOpen = onOpen
    }

    package var body: some View {
        TimelineView(.periodic(from: .now, by: DayPanelMetrics.tick)) { context in
            VStack(alignment: .leading, spacing: KbSpacing.s5) {
                DayPanelHeading(day: day?.day ?? context.date)
                Rectangle()
                    .fill(KbColors.separator)
                    .frame(height: KbPopoverMetrics.dividerHeight)
                DayPanelBody(day: day, now: context.date, onOpen: onOpen)
            }
            .padding(.horizontal, KbSpacing.s6)
            .padding(.top, KbSpacing.s6)
            .padding(.bottom, KbSpacing.s6 + KbPopoverMetrics.arrowSize.height)
        }
        .frame(width: DayPanelMetrics.panelWidth, alignment: .leading)
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: arrowX))
        .overlay { KbPopoverEdge(arrowX: arrowX) }
    }
}
