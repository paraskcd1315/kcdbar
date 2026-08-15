import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTotalsFigure: View {
    package let label: LocalizedStringKey
    package let seconds: Int
    package let tone: Color

    package var body: some View {
        HStack(spacing: KbSpacing.s1) {
            Text(label)
                .font(KbTypography.clockDate)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .textCase(.uppercase)
            Text(TimerFormatting.compact(seconds))
                .font(KbTypography.clockTime)
                .foregroundStyle(tone)
                .monospacedDigit()
        }
        .lineLimit(1)
    }
}
