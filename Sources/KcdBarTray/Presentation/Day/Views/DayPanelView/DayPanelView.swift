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

package struct DayPanelView: View {
    package let day: TrackerDay?
    package let arrowX: CGFloat
    package let presentation: PopoverPresentation
    package let onOpen: (DayEntry) -> Void

    package init(
        day: TrackerDay?,
        arrowX: CGFloat,
        presentation: PopoverPresentation,
        onOpen: @escaping (DayEntry) -> Void
    ) {
        self.day = day
        self.arrowX = arrowX
        self.presentation = presentation
        self.onOpen = onOpen
    }

    package var body: some View {
        GlassEffectContainer {
            DayPanelSurface(day: day, arrowX: arrowX, onOpen: onOpen)
        }
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }
}
