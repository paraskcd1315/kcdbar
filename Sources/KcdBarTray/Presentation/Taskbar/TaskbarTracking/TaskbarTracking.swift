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
