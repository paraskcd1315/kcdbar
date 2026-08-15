import SwiftUI

struct ConnectivityRow<Glyph: View>: View {
    let titleKey: LocalizedStringKey
    let statusKey: LocalizedStringKey
    let isOn: Bool
    let onToggle: () -> Void
    let onOpen: (() -> Void)?
    @ViewBuilder let glyph: Glyph

    var body: some View {
        HStack(spacing: KbSpacing.s5) {
            glyph
                .foregroundStyle(isOn ? KbColors.onBrand : KbColors.onSurface)
                .frame(
                    width: KbControlCentreMetrics.rowGlyphSize,
                    height: KbControlCentreMetrics.rowGlyphSize
                )
                .background(Circle().fill(isOn ? KbColors.brand : KbColors.surfaceRaised))
                .contentShape(Circle())
                .onTapGesture(perform: onToggle)
            VStack(alignment: .leading, spacing: 0) {
                Text(titleKey)
                    .font(KbTypography.tileTitle)
                    .foregroundStyle(KbColors.onSurface)
                Text(statusKey)
                    .font(KbTypography.tileStatus)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
            Spacer(minLength: KbSpacing.s4)
            if onOpen != nil {
                Image(systemName: KbControlCentreMetrics.chevronSymbol)
                    .font(KbTypography.tileStatus)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { onOpen?() }
    }
}
