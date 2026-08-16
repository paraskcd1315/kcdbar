import KcdBarDesignSystem
import SwiftUI

package struct TimerPanelRow: View {
    package let timer: RunningTimer
    package let now: Date
    package let onOpen: () -> Void

    @State private var isHovered = false

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
                    if timer.opensATicket {
                        Image(systemName: TimerReadoutMetrics.openSymbol)
                            .font(KbTypography.panelDetail)
                            .foregroundStyle(
                                isHovered ? KbColors.brand : KbColors.onSurfaceMuted
                            )
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
        .padding(.vertical, KbSpacing.s1)
        .padding(.horizontal, KbSpacing.s2)
        .background(isHovered && timer.opensATicket ? KbColors.separator : .clear, in: shape)
        .kbTappable(in: shape, perform: onOpen)
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.sm, style: .continuous)
    }
}
