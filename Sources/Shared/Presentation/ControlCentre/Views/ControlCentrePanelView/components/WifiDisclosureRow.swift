import SwiftUI

struct WifiDisclosureRow: View {
    let titleKey: LocalizedStringKey
    let isExpanded: Bool
    let onToggle: () -> Void

    @State private var isHovered = false

    var body: some View {
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
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: KbRadii.sm)
                .fill(isHovered ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity) : .clear)
        )
        .onHover { isHovered = $0 }
        .onTapGesture(perform: onToggle)
    }
}
