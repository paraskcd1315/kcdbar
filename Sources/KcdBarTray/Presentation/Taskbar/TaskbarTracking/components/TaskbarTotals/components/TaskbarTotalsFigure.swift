import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTotalsFigure: View {
    package let label: LocalizedStringKey
    package let seconds: Int
    package let tone: Color

    package var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: KbSpacing.s1) {
            Text(label)
                .font(KbTypography.trackingLabel)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .textCase(.uppercase)
            Text(TimerFormatting.compact(seconds))
                .font(KbTypography.clockDate)
                .foregroundStyle(tone)
                .monospacedDigit()
        }
        .lineLimit(1)
    }
}
