import KcdBarDesignSystem
import SwiftUI

package struct TaskbarBatteryFill: View {
    package let state: BatteryState

    package var body: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: BatteryMetrics.pillRadius - BatteryMetrics.pillBorderWidth)
                .fill(BatteryTint.colour(for: BatteryStyle.tone(for: state)))
                .frame(width: proxy.size.width * BatteryStyle.fill(for: state))
                .padding(BatteryMetrics.pillBorderWidth)
        }
        .animation(KbMotion.standard, value: state.percentage)
    }
}
