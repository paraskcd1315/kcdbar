import SwiftUI

struct TaskbarBatteryPill: View {
    let state: BatteryState

    var body: some View {
        HStack(spacing: BatteryMetrics.capGap) {
            ZStack {
                RoundedRectangle(cornerRadius: BatteryMetrics.pillRadius)
                    .stroke(KbColors.onSurfaceMuted, lineWidth: BatteryMetrics.pillBorderWidth)
                fill
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

    private var fill: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: BatteryMetrics.pillRadius - BatteryMetrics.pillBorderWidth)
                .fill(KbColors.battery(BatteryStyle.tone(for: state)))
                .frame(width: proxy.size.width * BatteryStyle.fill(for: state))
                .padding(BatteryMetrics.pillBorderWidth)
        }
        .animation(KbMotion.standard, value: state.percentage)
    }

    private var percentage: String {
        "\(state.percentage)"
    }
}
