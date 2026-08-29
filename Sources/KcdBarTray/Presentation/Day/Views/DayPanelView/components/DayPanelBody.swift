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

package struct DayPanelBody: View {
    package let day: TrackerDay?
    package let now: Date
    package let onOpen: (DayEntry) -> Void

    package init(day: TrackerDay?, now: Date, onOpen: @escaping (DayEntry) -> Void) {
        self.day = day
        self.now = now
        self.onOpen = onOpen
    }

    package var body: some View {
        switch DayPanelReading.of(day, at: now) {
        case .absent: DayPanelNotice(message: "day.absent")
        case .stale: DayPanelNotice(message: "day.stale")
        case .empty: DayPanelNotice(message: "day.empty")
        case .tracked(let tracked):
            DayGrid(
                day: tracked,
                blocks: DayLayout.blocks(of: tracked.entries, on: tracked.day, at: now),
                now: now,
                showsNow: true,
                onOpen: onOpen
            )
        }
    }
}
