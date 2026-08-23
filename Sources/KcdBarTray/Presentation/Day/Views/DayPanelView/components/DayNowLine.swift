import KcdBarDesignSystem
import SwiftUI

package struct DayNowLine: View {
    package init() {}

    package var body: some View {
        HStack(spacing: 0) {
            Circle()
                .fill(KbColors.brand)
                .frame(
                    width: DayPanelMetrics.nowDotSide,
                    height: DayPanelMetrics.nowDotSide
                )
            Rectangle()
                .fill(KbColors.brand)
                .frame(height: DayPanelMetrics.ruleHeight)
        }
        .allowsHitTesting(false)
    }
}
