import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTimer: View {
    package let monitor: TimerMonitor
    package let onOpen: () -> Void

    @State private var isHovered = false

    package init(monitor: TimerMonitor, onOpen: @escaping () -> Void) {
        self.monitor = monitor
        self.onOpen = onOpen
    }

    package var body: some View {
        let running = monitor.reading.timers

        if !running.isEmpty {
            readout(for: running)
        }
    }

    private func readout(for timers: [RunningTimer]) -> some View {
        TimelineView(.periodic(from: anchor(of: timers), by: TimerReadoutMetrics.tick)) { context in
            HStack(spacing: KbSpacing.s2) {
                Image(systemName: TimerReadoutMetrics.glyphSymbol)
                    .foregroundStyle(KbColors.brand)
                if let only = monitor.reading.only {
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
            .padding(.vertical, KbSpacing.s1)
            .fixedSize(horizontal: true, vertical: false)
        }
        .kbTappable(in: shape, perform: onOpen)
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: shape)
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
    }

    private func anchor(of timers: [RunningTimer]) -> Date {
        TimerTotals.earliest(of: timers) ?? .now
    }

    private var shape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.sm))
    }
}
