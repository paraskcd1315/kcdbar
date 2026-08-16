import KcdBarDesignSystem
import SwiftUI

package struct StartMenuSearchField: View {
    package let onOpen: () -> Void

    package init(onOpen: @escaping () -> Void) {
        self.onOpen = onOpen
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s4) {
            Image(systemName: StartMenuMetrics.searchGlyph)
                .font(KbTypography.menuItem)
                .foregroundStyle(KbColors.onSurfaceMuted)
            Text("start.search.spotlight")
                .font(KbTypography.menuItem)
                .foregroundStyle(KbColors.onSurfaceMuted)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, KbSpacing.s4)
        .padding(.vertical, KbSpacing.s3)
        .glassEffect(.regular.interactive(), in: shape)
        .overlay(shape.stroke(KbColors.separator, lineWidth: KbEdgeMetrics.width))
        .kbTappable(in: shape, perform: onOpen)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.md, style: .continuous)
    }
}
