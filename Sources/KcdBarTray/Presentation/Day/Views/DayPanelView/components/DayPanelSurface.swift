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
