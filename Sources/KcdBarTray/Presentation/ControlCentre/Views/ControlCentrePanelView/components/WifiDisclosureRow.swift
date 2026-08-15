import KcdBarDesignSystem
import SwiftUI

package struct WifiDisclosureRow: View {
    package let titleKey: LocalizedStringKey
    package let isExpanded: Bool
    package let onToggle: () -> Void

    @State private var isHovered = false

    package var body: some View {
        HStack {
            Text(titleKey)
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
            Spacer(minLength: KbSpacing.s3)
            Image(systemName: WifiMetrics.chevronSymbol)
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .rotationEffect(.degrees(isExpanded ? 90 : 0))
        }
        .padding(.horizontal, KbSpacing.s4)
        .frame(height: WifiMetrics.rowHeight)
        .background(
            RoundedRectangle(cornerRadius: KbRadii.sm)
                .fill(isHovered ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity) : .clear)
        )
        .onHover { isHovered = $0 }
        .kbTappable(in: Rectangle(), perform: onToggle)
    }
}
