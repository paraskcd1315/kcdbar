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

package struct TaskbarTracking: View {
    package let timer: TimerMonitor
    package let totals: TotalsMonitor
    package let onOpenDay: () -> Void

    @State private var isHovered = false

    package init(timer: TimerMonitor, totals: TotalsMonitor, onOpenDay: @escaping () -> Void) {
        self.timer = timer
        self.totals = totals
        self.onOpenDay = onOpenDay
    }

    package var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TaskbarTimer(monitor: timer)
            TaskbarTotals(monitor: totals)
        }
        .padding(.vertical, KbSpacing.s1)
        .fixedSize(horizontal: true, vertical: false)
        .kbTappable(in: shape, perform: onOpenDay)
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: shape)
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
    }

    private var shape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.sm))
    }
}
