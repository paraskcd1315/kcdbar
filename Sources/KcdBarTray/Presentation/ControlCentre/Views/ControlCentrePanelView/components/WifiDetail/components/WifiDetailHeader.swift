import KcdBarDesignSystem
import SwiftUI

package struct WifiDetailHeader: View {
    package let isPowered: Bool
    package let onBack: () -> Void
    package let onSetPower: (Bool) -> Void

    @State private var isHovered = false

    package var body: some View {
        HStack(spacing: KbSpacing.s5) {
            HStack(spacing: KbSpacing.s3) {
                Image(systemName: KbControlCentreMetrics.backSymbol)
                    .font(KbTypography.tileStatus)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                Text("wifi.title")
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(KbColors.onSurface)
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
            Spacer(minLength: KbSpacing.s5)
            WifiToggle(isOn: isPowered, onToggle: onSetPower)
        }
    }
}
