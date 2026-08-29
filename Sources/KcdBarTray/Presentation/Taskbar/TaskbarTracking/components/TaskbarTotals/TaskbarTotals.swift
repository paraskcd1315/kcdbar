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

package struct TaskbarTotals: View {
    package let monitor: TotalsMonitor

    package init(monitor: TotalsMonitor) {
        self.monitor = monitor
    }

    package var body: some View {
        if let totals = monitor.totals {
            HStack(alignment: .firstTextBaseline, spacing: KbSpacing.s3) {
                TaskbarTotalsFigure(
                    label: "totals.today",
                    seconds: totals.todaySeconds,
                    tone: KbColors.onSurface
                )
                TaskbarTotalsFigure(
                    label: "totals.week",
                    seconds: totals.weekSeconds,
                    tone: KbColors.onSurface
                )
                if let pace = totals.pace {
                    TaskbarTotalsPace(pace: pace)
                }
            }
            .padding(.horizontal, KbSpacing.s4)
            .fixedSize(horizontal: true, vertical: false)
        }
    }
}
