import KcdBarDesignSystem
import SwiftUI

package struct ConnectivityRow<Glyph: View>: View {
    package let titleKey: LocalizedStringKey
    package let statusKey: LocalizedStringKey
    package let isOn: Bool
    package let onToggle: () -> Void
    package let onOpen: (() -> Void)?
    @ViewBuilder package let glyph: Glyph

    package var body: some View {
        HStack(spacing: KbSpacing.s5) {
            glyph
                .foregroundStyle(isOn ? KbColors.onBrand : KbColors.onSurface)
                .frame(
                    width: KbControlCentreMetrics.rowGlyphSize,
                    height: KbControlCentreMetrics.rowGlyphSize
                )
                .background(Circle().fill(isOn ? KbColors.brand : KbColors.surfaceRaised))
                .kbTappable(in: Circle(), perform: onToggle)
            VStack(alignment: .leading, spacing: 0) {
                Text(titleKey)
                    .font(KbTypography.tileTitle)
                    .foregroundStyle(KbColors.onSurface)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(statusKey)
                    .font(KbTypography.tileStatus)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if onOpen != nil {
                Image(systemName: KbControlCentreMetrics.chevronSymbol)
                    .font(KbTypography.tileStatus)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .fixedSize()
            }
        }
        .frame(height: KbControlCentreMetrics.rowHeight)
        .kbTappable(in: Rectangle()) { onOpen?() }
    }
}
