import SwiftUI

struct BatteryPanelEnergyList: View {
    let users: [EnergyUser]

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s2) {
            Text("battery.energy.heading")
                .font(KbTypography.panelDetail)
                .foregroundStyle(KbColors.onSurfaceMuted)
            ForEach(users) { user in
                Text(user.name)
                    .font(KbTypography.panelDetail)
                    .foregroundStyle(KbColors.onSurface)
                    .lineLimit(1)
            }
        }
    }
}
