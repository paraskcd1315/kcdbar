import KcdBarDesignSystem
import SwiftUI

package struct BatteryPanelEnergySkeleton: View {
    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            Text("battery.energy.heading")
                .font(KbTypography.panelDetail)
                .foregroundStyle(KbColors.onSurfaceMuted)
            VStack(alignment: .leading, spacing: KbSpacing.s2) {
                ForEach(BatteryMetrics.skeletonWidths, id: \.self) { width in
                    KbSkeleton(width: width)
                }
            }
        }
    }
}
