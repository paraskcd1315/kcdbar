import KcdBarDesignSystem
import SwiftUI

package struct TaskbarClock: View {
    package let onOpen: () -> Void

    @State private var isHovered = false

    package init(onOpen: @escaping () -> Void) {
        self.onOpen = onOpen
    }

    package var body: some View {
        TimelineView(.everyMinute) { context in
            VStack(alignment: .trailing, spacing: 0) {
                Text(context.date, format: .dateTime.hour().minute())
                    .font(KbTypography.clockTime)
                    .foregroundStyle(KbColors.onSurface)
                Text(ClockFormatting.naturalDate(context.date))
                    .font(KbTypography.clockDate)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
            .monospacedDigit()
            .padding(.horizontal, KbSpacing.s4)
            .padding(.vertical, KbSpacing.s1)
        }
        .kbTappable(in: shape, perform: onOpen)
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: shape)
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
    }

    private var shape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.sm))
    }
}
