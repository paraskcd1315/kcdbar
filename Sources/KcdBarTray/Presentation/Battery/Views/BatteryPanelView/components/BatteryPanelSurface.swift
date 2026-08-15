import KcdBarDesignSystem
import SwiftUI

package struct BatteryPanelSurface: View {
    package let state: BatteryState
    package let energyUsers: [EnergyUser]
    package let arrowX: CGFloat

    package var body: some View {
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
        .overlay { KbPopoverEdge(arrowX: arrowX) }
    }
}
