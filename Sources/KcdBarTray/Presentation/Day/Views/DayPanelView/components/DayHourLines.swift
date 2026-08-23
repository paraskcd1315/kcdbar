import KcdBarDesignSystem
import SwiftUI

package struct DayHourLines: View {
    package init() {}

    package var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<DayPanelMetrics.hoursInDay, id: \.self) { hour in
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(KbColors.separator)
                        .frame(height: DayPanelMetrics.ruleHeight)
                    Spacer(minLength: 0)
                    Rectangle()
                        .fill(
                            KbColors.separator.opacity(DayPanelMetrics.halfHourOpacity)
                        )
                        .frame(height: DayPanelMetrics.ruleHeight)
                    Spacer(minLength: 0)
                }
                .frame(height: DayPanelMetrics.hourHeight)
                .id(hour)
            }
        }
    }
}
