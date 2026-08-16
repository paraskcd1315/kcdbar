import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTracking: View {
    package let timer: TimerMonitor
    package let totals: TotalsMonitor
    package let onOpenTimer: () -> Void

    package init(timer: TimerMonitor, totals: TotalsMonitor, onOpenTimer: @escaping () -> Void) {
        self.timer = timer
        self.totals = totals
        self.onOpenTimer = onOpenTimer
    }

    package var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TaskbarTimer(monitor: timer, onOpen: onOpenTimer)
            TaskbarTotals(monitor: totals)
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}
