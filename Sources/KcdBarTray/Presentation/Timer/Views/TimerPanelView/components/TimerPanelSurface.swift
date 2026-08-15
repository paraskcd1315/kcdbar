import KcdBarDesignSystem
import SwiftUI

package struct TimerPanelSurface: View {
    package let timers: [RunningTimer]
    package let arrowX: CGFloat

    package var body: some View {
        TimelineView(.periodic(from: anchor, by: TimerReadoutMetrics.tick)) { context in
            VStack(alignment: .leading, spacing: KbSpacing.s5) {
                TimerPanelHeader(timers: timers, now: context.date)
                Rectangle()
                    .fill(KbColors.separator)
                    .frame(height: KbPopoverMetrics.dividerHeight)
                TimerPanelList(timers: timers, now: context.date)
            }
            .padding(.horizontal, KbSpacing.s6)
            .padding(.top, KbSpacing.s6)
            .padding(.bottom, KbSpacing.s6 + KbPopoverMetrics.arrowSize.height)
        }
        .frame(width: TimerReadoutMetrics.panelWidth, alignment: .leading)
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: arrowX))
        .overlay { KbPopoverEdge(arrowX: arrowX) }
    }

    private var anchor: Date {
        TimerTotals.earliest(of: timers) ?? .now
    }
}
