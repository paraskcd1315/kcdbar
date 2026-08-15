import KcdBarDesignSystem
import SwiftUI

package struct BatteryPanelEnergyList: View {
    package let users: [EnergyUser]

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            Text("battery.energy.heading")
                .font(KbTypography.panelDetail)
                .foregroundStyle(KbColors.onSurfaceMuted)
            VStack(alignment: .leading, spacing: KbSpacing.s2) {
                ForEach(users) { user in
                    Text(user.name)
                        .font(KbTypography.panelItem)
                        .foregroundStyle(KbColors.onSurface)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
    }
}
