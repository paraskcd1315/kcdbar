import KcdBarDesignSystem
import SwiftUI

package struct ControlCentreSettingsRow: View {
    package let titleKey: LocalizedStringKey
    package let onOpen: () -> Void

    @State private var isHovered = false

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s2) {
            Rectangle()
                .fill(KbColors.separator)
                .frame(height: KbPopoverMetrics.dividerHeight)
            Text(titleKey)
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
                .padding(.horizontal, KbSpacing.s4)
                .frame(height: KbControlCentreMetrics.settingsRowHeight, alignment: .leading)
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
