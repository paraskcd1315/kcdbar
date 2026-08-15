import KcdBarDesignSystem
import SwiftUI

package struct WifiNetworkRow: View {
    package let network: WifiNetwork

    @State private var isHovered = false

    package var body: some View {
        HStack(spacing: KbSpacing.s4) {
            Image(systemName: WifiStyle.symbol(for: network))
                .font(.system(size: WifiMetrics.rowGlyphSize * KbControlCentreMetrics.glyphRatio))
                .foregroundStyle(network.isCurrent ? KbColors.onBrand : KbColors.onSurface)
                .frame(width: WifiMetrics.rowGlyphSize, height: WifiMetrics.rowGlyphSize)
                .background(Circle().fill(network.isCurrent ? KbColors.brand : KbColors.surfaceRaised))
            Text(network.ssid)
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: KbSpacing.s3)
            if network.isSecure {
                Image(systemName: WifiMetrics.lockSymbol)
                    .font(KbTypography.tileStatus)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
        }
        .padding(.horizontal, KbSpacing.s4)
        .frame(height: WifiMetrics.rowHeight)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: KbRadii.sm)
                .fill(isHovered ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity) : .clear)
        )
        .onHover { isHovered = $0 }
    }
}
