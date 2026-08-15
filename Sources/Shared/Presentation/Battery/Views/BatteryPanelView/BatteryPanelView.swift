import SwiftUI

struct BatteryPanelView: View {
    let state: BatteryState
    let energyUsers: [EnergyUser]
    let arrowX: CGFloat
    let presentation: PopoverPresentation

    var body: some View {
        GlassEffectContainer {
            panel
        }
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }

    private var panel: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s5) {
            BatteryPanelHeader(state: state)
            if !energyUsers.isEmpty {
                Rectangle()
                    .fill(KbColors.separator)
                    .frame(height: KbPopoverMetrics.dividerHeight)
                BatteryPanelEnergyList(users: energyUsers)
            }
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.top, KbSpacing.s6)
        .padding(.bottom, KbSpacing.s6 + KbPopoverMetrics.arrowSize.height)
        .frame(width: BatteryMetrics.panelWidth, alignment: .leading)
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: arrowX))
    }
}
