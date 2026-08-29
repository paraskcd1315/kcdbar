import KcdBarDesignSystem
import SwiftUI

package struct TaskbarEntryBadge: View {
    package var body: some View {
        Image(systemName: TaskbarMetrics.fullScreenBadgeSymbol)
            .font(.system(size: TaskbarMetrics.fullScreenBadgeGlyph, weight: .bold))
            .foregroundStyle(KbColors.onSurface)
            .frame(width: TaskbarMetrics.fullScreenBadgeSide, height: TaskbarMetrics.fullScreenBadgeSide)
            .background(KbColors.bandFill, in: .circle)
            .overlay {
                Circle().strokeBorder(KbColors.separator, lineWidth: TaskbarMetrics.separatorThickness)
            }
    }
}
