import KcdBarDesignSystem
import SwiftUI

package struct ControlCentreDetailTitle: View {
    package let title: String
    package let onBack: () -> Void

    @State private var isHovered = false

    package init(title: String, onBack: @escaping () -> Void) {
        self.title = title
        self.onBack = onBack
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            Image(systemName: KbControlCentreMetrics.backSymbol)
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
            Text(title)
                .font(KbTypography.panelTitle)
                .foregroundStyle(KbColors.onSurface)
                .lineLimit(1)
        }
        .padding(.horizontal, KbSpacing.s3)
        .padding(.vertical, KbSpacing.s2)
        .background(
            RoundedRectangle(cornerRadius: KbRadii.md, style: .continuous)
                .fill(isHovered ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity) : .clear)
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onBack)
        .onHover { isHovered = $0 }
    }
}
