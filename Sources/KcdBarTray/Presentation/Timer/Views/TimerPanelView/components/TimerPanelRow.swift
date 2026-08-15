import KcdBarDesignSystem
import SwiftUI

package struct TimerPanelRow: View {
    package let timer: RunningTimer
    package let now: Date

    package var body: some View {
        HStack(alignment: .top, spacing: KbSpacing.s4) {
            VStack(alignment: .leading, spacing: KbSpacing.s1) {
                HStack(spacing: KbSpacing.s2) {
                    Text(TimerFormatting.label(for: timer))
                        .font(KbTypography.panelItem)
                        .foregroundStyle(KbColors.onSurface)
                    if timer.isBillable {
                        Image(systemName: TimerReadoutMetrics.billableSymbol)
                            .font(KbTypography.panelDetail)
                            .foregroundStyle(KbColors.brand)
                    }
                }
                Text(timer.detail)
                    .font(KbTypography.panelDetail)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: KbSpacing.s4)
            Text(TimerFormatting.elapsed(since: timer.startedAt, at: now))
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
                .monospacedDigit()
        }
    }
}
