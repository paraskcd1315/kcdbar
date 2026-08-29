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

package struct TaskbarTimerReadout: View {
    package let timers: [RunningTimer]
    package let only: RunningTimer?

    package var body: some View {
        TimelineView(.periodic(from: anchor, by: TimerReadoutMetrics.tick)) { context in
            HStack(spacing: KbSpacing.s2) {
                Image(systemName: TimerReadoutMetrics.glyphSymbol)
                    .foregroundStyle(KbColors.brand)
                if let only {
                    Text(TimerFormatting.label(for: only))
                        .foregroundStyle(KbColors.onSurface)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: TimerReadoutMetrics.labelWidth, alignment: .leading)
                } else {
                    Text("timer.running.count \(timers.count)")
                        .foregroundStyle(KbColors.onSurface)
                        .monospacedDigit()
                        .lineLimit(1)
                }
                Text(TimerFormatting.duration(TimerTotals.elapsed(of: timers, at: context.date)))
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .monospacedDigit()
                    .lineLimit(1)
            }
            .font(KbTypography.clockTime)
            .padding(.horizontal, KbSpacing.s4)
            .fixedSize(horizontal: true, vertical: false)
        }
    }

    private var anchor: Date {
        TimerTotals.earliest(of: timers) ?? .now
    }
}
