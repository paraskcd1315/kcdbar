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
            .padding(.vertical, KbSpacing.s1)
            .fixedSize(horizontal: true, vertical: false)
        }
    }
}
