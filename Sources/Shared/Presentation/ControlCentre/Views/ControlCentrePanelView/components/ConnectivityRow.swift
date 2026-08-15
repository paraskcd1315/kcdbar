import SwiftUI

struct ConnectivityRow: View {
    let symbol: String
    let titleKey: LocalizedStringKey
    let statusKey: LocalizedStringKey
    let isOn: Bool
    let onToggle: () -> Void
    let onOpen: (() -> Void)?

    var body: some View {
        HStack(spacing: KbSpacing.s5) {
            Image(systemName: symbol)
                .font(.system(size: KbControlCentreMetrics.rowGlyphSize * KbControlCentreMetrics.glyphRatio))
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
