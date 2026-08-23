import KcdBarDesignSystem
import SwiftUI

package struct DayPanelHeading: View {
    package let day: Date

    package init(day: Date) {
        self.day = day
    }

    package var body: some View {
        HStack {
            Text("day.title")
                .font(KbTypography.panelTitle)
                .foregroundStyle(KbColors.onSurface)
            Spacer(minLength: KbSpacing.s5)
            Text(DayFormatting.heading(day))
                .font(KbTypography.panelDetail)
                .foregroundStyle(KbColors.onSurfaceMuted)
        }
    }
}
