import SwiftUI

struct TaskbarBatteryFill: View {
    let state: BatteryState

    var body: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: BatteryMetrics.pillRadius - BatteryMetrics.pillBorderWidth)
                .fill(KbColors.battery(BatteryStyle.tone(for: state)))
                .frame(width: proxy.size.width * BatteryStyle.fill(for: state))
                .padding(BatteryMetrics.pillBorderWidth)
        }
        .animation(KbMotion.standard, value: state.percentage)
    }
}
