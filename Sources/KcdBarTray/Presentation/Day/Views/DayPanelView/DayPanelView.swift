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
