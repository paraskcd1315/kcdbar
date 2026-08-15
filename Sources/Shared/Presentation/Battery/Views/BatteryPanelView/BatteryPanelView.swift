import SwiftUI

struct BatteryPanelView: View {
    let state: BatteryState
    let energyUsers: [EnergyUser]
    let arrowX: CGFloat
    let presentation: BatteryPanelPresentation

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s5) {
            BatteryPanelHeader(state: state)
            if !energyUsers.isEmpty {
                Rectangle()
                    .fill(KbColors.separator)
                    .frame(height: BatteryMetrics.dividerHeight)
                BatteryPanelEnergyList(users: energyUsers)
            }
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.top, KbSpacing.s6)
        .padding(.bottom, KbSpacing.s6 + BatteryMetrics.arrowSize.height)
        .frame(width: BatteryMetrics.panelWidth, alignment: .leading)
        .glassEffect(.regular, in: BatteryPopoverShape(arrowX: arrowX))
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : BatteryMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }
}
