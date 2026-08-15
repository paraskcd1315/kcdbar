import KcdBarDesignSystem
import SwiftUI

package struct TimerPanelView: View {
    package let timers: [RunningTimer]
    package let arrowX: CGFloat
    package let presentation: PopoverPresentation

    package var body: some View {
        GlassEffectContainer {
            TimerPanelSurface(timers: timers, arrowX: arrowX)
        }
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }
}
