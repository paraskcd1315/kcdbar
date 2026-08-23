import KcdBarDesignSystem
import SwiftUI

package struct DayEntryBlockTitle: View {
    package let entry: DayEntry
    package let tone: Color

    package init(entry: DayEntry, tone: Color) {
        self.entry = entry
        self.tone = tone
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s1) {
            Text(DayFormatting.label(for: entry))
                .font(KbTypography.trackingLabel)
                .foregroundStyle(KbColors.onSurface)
                .lineLimit(1)
                .truncationMode(.tail)

            if entry.isBillable {
                Image(systemName: DayPanelMetrics.billableSymbol)
                    .font(.system(size: DayPanelMetrics.glyphSide))
                    .foregroundStyle(KbColors.batteryFull)
            }

            if entry.opensATicket {
                Image(systemName: DayPanelMetrics.openSymbol)
                    .font(.system(size: DayPanelMetrics.glyphSide))
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }

            Spacer(minLength: 0)
        }
    }
}
