import KcdBarDesignSystem
import SwiftUI

package struct DayHourRuler: View {
    package init() {}

    package var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ForEach(0..<DayPanelMetrics.hoursInDay, id: \.self) { hour in
                Text(DayFormatting.hour(hour))
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .frame(
                        width: DayPanelMetrics.rulerWidth,
                        height: DayPanelMetrics.hourHeight,
                        alignment: .topTrailing
                    )
                    .padding(.trailing, KbSpacing.s2)
            }
        }
        .frame(width: DayPanelMetrics.rulerWidth)
    }
}
