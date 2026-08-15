import KcdBarDesignSystem
import SwiftUI

package struct TaskbarBatteryPill: View {
    package let state: BatteryState

    package var body: some View {
        HStack(spacing: BatteryMetrics.capGap) {
            ZStack {
                RoundedRectangle(cornerRadius: BatteryMetrics.pillRadius)
                    .stroke(KbColors.onSurfaceMuted, lineWidth: BatteryMetrics.pillBorderWidth)
                TaskbarBatteryFill(state: state)
                Text(percentage)
                    .font(KbTypography.batteryReadout)
                    .foregroundStyle(KbColors.onSurface)
            }
            .frame(width: BatteryMetrics.pillWidth, height: BatteryMetrics.pillHeight)
            RoundedRectangle(cornerRadius: BatteryMetrics.capWidth / 2)
                .fill(KbColors.onSurfaceMuted)
                .frame(width: BatteryMetrics.capWidth, height: BatteryMetrics.capHeight)
        }
    }

    private var percentage: String {
        "\(state.percentage)"
    }
}
