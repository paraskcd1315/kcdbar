import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTimerReadout: View {
    package let timers: [RunningTimer]
    package let only: RunningTimer?

    package var body: some View {
        TimelineView(.periodic(from: anchor, by: TimerReadoutMetrics.tick)) { context in
            HStack(spacing: KbSpacing.s2) {
                Image(systemName: TimerReadoutMetrics.glyphSymbol)
                    .foregroundStyle(KbColors.brand)
                if let only {
                    Text(TimerFormatting.label(for: only))
                        .foregroundStyle(KbColors.onSurface)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: TimerReadoutMetrics.labelWidth, alignment: .leading)
                } else {
                    Text("timer.running.count \(timers.count)")
                        .foregroundStyle(KbColors.onSurface)
                        .monospacedDigit()
                        .lineLimit(1)
                }
                Text(TimerFormatting.duration(TimerTotals.elapsed(of: timers, at: context.date)))
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .monospacedDigit()
                    .lineLimit(1)
            }
            .font(KbTypography.clockTime)
            .padding(.horizontal, KbSpacing.s4)
            .fixedSize(horizontal: true, vertical: false)
        }
    }

    private var anchor: Date {
        TimerTotals.earliest(of: timers) ?? .now
    }
}
