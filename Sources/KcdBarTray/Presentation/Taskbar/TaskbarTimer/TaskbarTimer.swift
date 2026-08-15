import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTimer: View {
    package let monitor: TimerMonitor

    @State private var isHovered = false

    package init(monitor: TimerMonitor) {
        self.monitor = monitor
    }

    package var body: some View {
        if let timer = monitor.reading.timer {
            readout(for: timer)
        }
    }

    private func readout(for timer: RunningTimer) -> some View {
        TimelineView(.periodic(from: timer.startedAt, by: TimerReadoutMetrics.tick)) { context in
            HStack(spacing: KbSpacing.s2) {
                Image(systemName: TimerReadoutMetrics.glyphSymbol)
                    .foregroundStyle(KbColors.brand)
                Text(TimerFormatting.label(for: timer))
                    .font(KbTypography.clockTime)
                    .foregroundStyle(KbColors.onSurface)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: TimerReadoutMetrics.labelWidth, alignment: .leading)
                Text(TimerFormatting.elapsed(since: timer.startedAt, at: context.date))
                    .font(KbTypography.clockTime)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .monospacedDigit()
            }
            .padding(.horizontal, KbSpacing.s4)
            .padding(.vertical, KbSpacing.s1)
        }
        .help(timer.detail)
        .contentShape(shape)
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: shape)
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
    }

    private var shape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.sm))
    }
}
