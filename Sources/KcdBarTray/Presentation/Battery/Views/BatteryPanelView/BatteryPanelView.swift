import KcdBarDesignSystem
import SwiftUI

package struct BatteryPanelView: View {
    package let state: BatteryState
    package let energyUsers: [EnergyUser]
    package let isSampling: Bool
    package let arrowX: CGFloat
    package let presentation: PopoverPresentation

    package var body: some View {
        GlassEffectContainer {
            BatteryPanelSurface(
                state: state,
                energyUsers: energyUsers,
                isSampling: isSampling,
                arrowX: arrowX
            )
        }
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }
}
