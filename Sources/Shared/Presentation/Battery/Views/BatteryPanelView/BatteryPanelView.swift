import SwiftUI

struct BatteryPanelView: View {
    let state: BatteryState
    let energyUsers: [EnergyUser]
    let arrowX: CGFloat
    let presentation: PopoverPresentation

    var body: some View {
        GlassEffectContainer {
            BatteryPanelSurface(state: state, energyUsers: energyUsers, arrowX: arrowX)
        }
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }
}
