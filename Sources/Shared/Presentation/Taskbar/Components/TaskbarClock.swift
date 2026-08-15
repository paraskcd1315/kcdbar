import SwiftUI

struct TaskbarClock: View {
    var body: some View {
        TimelineView(.everyMinute) { context in
            VStack(alignment: .trailing, spacing: 0) {
                Text(context.date, format: .dateTime.hour().minute())
                    .font(KbTypography.clockTime)
                    .foregroundStyle(KbColors.onSurface)
                Text(context.date, format: .dateTime.day().month(.twoDigits).year())
                    .font(KbTypography.clockDate)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
            .monospacedDigit()
            .padding(.horizontal, KbSpacing.s4)
        }
    }
}
