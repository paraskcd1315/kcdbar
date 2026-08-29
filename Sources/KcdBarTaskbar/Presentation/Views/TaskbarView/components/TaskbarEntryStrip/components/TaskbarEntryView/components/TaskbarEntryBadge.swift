import KcdBarDesignSystem
import SwiftUI

package struct TaskbarEntryBadge: View {
    package let count: Int

    package var body: some View {
        Image(systemName: TaskbarMetrics.fullScreenBadgeSymbol)
            .font(.system(size: TaskbarMetrics.fullScreenBadgeGlyph, weight: .bold))
            .foregroundStyle(KbColors.onSurface)
            .frame(width: TaskbarMetrics.fullScreenBadgeSide, height: TaskbarMetrics.fullScreenBadgeSide)
            .background(KbColors.bandFill, in: .circle)
            .overlay {
                Circle().strokeBorder(KbColors.separator, lineWidth: TaskbarMetrics.separatorThickness)
            }
            .overlay(alignment: .topTrailing) {
                if count > 1 {
                    TaskbarEntryBadgeCount(count: count)
                        .offset(
                            x: TaskbarMetrics.fullScreenCountSide / 2,
                            y: -TaskbarMetrics.fullScreenCountSide / 2
                        )
                }
            }
    }
}
