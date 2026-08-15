import SwiftUI

struct BatteryPanelView: View {
    let state: BatteryState
    let energyUsers: [EnergyUser]

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            BatteryPanelHeader(state: state)
            if !energyUsers.isEmpty {
                Divider().overlay(KbColors.separator)
                BatteryPanelEnergyList(users: energyUsers)
            }
        }
        .padding(KbSpacing.s4)
        .frame(width: BatteryMetrics.panelWidth, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: KbRadii.lg))
    }
}
