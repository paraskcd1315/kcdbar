import KcdBarDesignSystem
import SwiftUI

package struct TimerPanelHeader: View {
    package let timers: [RunningTimer]
    package let now: Date

    package var body: some View {
        HStack {
            Text("timer.title")
                .font(KbTypography.panelTitle)
                .foregroundStyle(KbColors.onSurface)
            Spacer(minLength: KbSpacing.s5)
            Text(TimerFormatting.duration(TimerTotals.elapsed(of: timers, at: now)))
                .font(KbTypography.panelTitle)
                .foregroundStyle(KbColors.brand)
                .monospacedDigit()
        }
    }
}
