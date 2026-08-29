import KcdBarDesignSystem
import SwiftUI

package struct TaskbarPreviewClose: View {
    package let onClose: () -> Void

    @State private var isHovered = false

    package var body: some View {
        Image(systemName: TaskbarMetrics.previewCloseSymbol)
            .font(.system(size: TaskbarMetrics.previewCloseGlyph, weight: .bold))
            .foregroundStyle(KbColors.onSurface)
            .frame(width: TaskbarMetrics.previewCloseSide, height: TaskbarMetrics.previewCloseSide)
            .background(isHovered ? KbColors.batteryCritical : KbColors.focusedFill, in: .circle)
            .overlay {
                Circle().strokeBorder(KbColors.separator, lineWidth: TaskbarMetrics.separatorThickness)
            }
            .contentShape(.circle)
            .onHover { isHovered = $0 }
            .onTapGesture(perform: onClose)
            .animation(KbMotion.quick, value: isHovered)
    }
}
