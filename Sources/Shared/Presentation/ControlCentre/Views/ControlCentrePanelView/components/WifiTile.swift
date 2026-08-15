import SwiftUI

struct WifiTile: View {
    let state: WifiState
    let onExpand: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: KbSpacing.s4) {
            Image(systemName: WifiStyle.symbol(for: state))
                .font(.system(size: WifiMetrics.glyphSize * KbControlCentreMetrics.glyphRatio))
                .foregroundStyle(state.isPowered ? KbColors.onBrand : KbColors.onSurface)
                .frame(width: WifiMetrics.glyphSize, height: WifiMetrics.glyphSize)
                .background(glyphBackground)
            VStack(alignment: .leading, spacing: 0) {
                Text("wifi.title")
                    .font(KbTypography.tileTitle)
                    .foregroundStyle(KbColors.onSurface)
                Text(statusKey)
                    .font(KbTypography.tileStatus)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
            Spacer(minLength: KbSpacing.s4)
            Image(systemName: WifiMetrics.chevronSymbol)
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
        }
        .padding(.horizontal, KbSpacing.s4)
        .padding(.vertical, KbSpacing.s3)
        .contentShape(Rectangle())
        .onTapGesture(perform: onExpand)
        .background(rowBackground)
        .onHover { isHovered = $0 }
    }

    private var glyphBackground: some View {
        Circle().fill(state.isPowered ? KbColors.brand : KbColors.surfaceRaised)
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: KbRadii.md)
            .fill(isHovered ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity) : .clear)
    }

    private var statusKey: LocalizedStringKey {
        guard state.isAvailable else { return "wifi.status.unavailable" }
        guard state.isPowered else { return "wifi.status.off" }

        return state.ssid.map { LocalizedStringKey($0) } ?? "wifi.status.on"
    }
}
