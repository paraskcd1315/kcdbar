import SwiftUI

struct ControlCentreDetailHeader: View {
    let titleKey: LocalizedStringKey
    let isOn: Bool
    let onBack: () -> Void
    let onSetPower: (Bool) -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: KbSpacing.s5) {
            HStack(spacing: KbSpacing.s3) {
                Image(systemName: KbControlCentreMetrics.backSymbol)
                    .font(KbTypography.tileStatus)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                Text(titleKey)
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(KbColors.onSurface)
            }
            .padding(.horizontal, KbSpacing.s3)
            .padding(.vertical, KbSpacing.s2)
            .background(
                RoundedRectangle(cornerRadius: KbRadii.md, style: .continuous)
                    .fill(
                        isHovered
                            ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity)
                            : .clear
                    )
            )
            .contentShape(Rectangle())
            .onTapGesture(perform: onBack)
            .onHover { isHovered = $0 }
            Spacer(minLength: KbSpacing.s5)
            WifiToggle(isOn: isOn, onToggle: onSetPower)
        }
    }
}
