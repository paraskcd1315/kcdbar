import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAccountMenu: View {
    package let userName: String
    package let avatar: Image?
    package let onPower: (StartPowerAction) -> Void

    @State private var isHovered = false

    package var body: some View {
        Menu {
            ForEach(StartPowerAction.accountActions) { action in
                Button {
                    onPower(action)
                } label: {
                    Label(LocalizedStringKey(action.titleKey), systemImage: action.symbol)
                }
            }
        } label: {
            HStack(spacing: KbSpacing.s3) {
                StartMenuAvatar(image: avatar)
                Text(userName)
                    .font(KbTypography.menuItem)
                    .foregroundStyle(KbColors.onSurface)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.horizontal, KbSpacing.s3)
            .padding(.vertical, KbSpacing.s2)
            .background(
                isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
                in: shape
            )
            .contentShape(shape)
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .frame(height: StartMenuMetrics.powerButtonSize)
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.md, style: .continuous)
    }
}
