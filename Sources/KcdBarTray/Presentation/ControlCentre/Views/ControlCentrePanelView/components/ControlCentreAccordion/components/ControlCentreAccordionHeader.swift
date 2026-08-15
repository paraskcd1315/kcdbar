import KcdBarDesignSystem
import SwiftUI

package struct ControlCentreAccordionHeader: View {
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
            Image(systemName: KbControlCentreMetrics.chevronSymbol)
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .rotationEffect(.degrees(isExpanded ? 90 : 0))
        }
        .padding(.horizontal, KbSpacing.s4)
        .frame(height: KbControlCentreMetrics.settingsRowHeight)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: KbRadii.sm)
                .fill(isHovered ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity) : .clear)
        )
        .onHover { isHovered = $0 }
        .onTapGesture(perform: onToggle)
    }
}
