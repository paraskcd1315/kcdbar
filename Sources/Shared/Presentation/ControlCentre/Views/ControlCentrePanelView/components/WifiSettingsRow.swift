import SwiftUI

struct WifiSettingsRow: View {
    let onOpen: () -> Void

    @State private var isHovered = false

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s2) {
            Rectangle()
                .fill(KbColors.separator)
                .frame(height: KbPopoverMetrics.dividerHeight)
            Text("wifi.settings")
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
                .padding(.horizontal, KbSpacing.s4)
                .frame(height: WifiMetrics.rowHeight, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: KbRadii.sm)
                        .fill(
                            isHovered
                                ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity)
                                : .clear
                        )
                )
                .onHover { isHovered = $0 }
                .onTapGesture(perform: onOpen)
        }
    }
}
