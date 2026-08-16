import KcdBarDesignSystem
import SwiftUI

package struct StartMenuBandHeading: View {
    package let section: ApplicationSection
    package let isShowing: Bool
    package let onIndex: () -> Void

    @State private var isHovered = false

    package var body: some View {
        ZStack {
            if isShowing {
                Group {
                    if let titleKey = section.titleKey {
                        Text(LocalizedStringKey(titleKey))
                    } else {
                        Text(section.key)
                    }
                }
                .font(KbTypography.panelDetail)
                .foregroundStyle(isHovered ? KbColors.onSurface : KbColors.onSurfaceMuted)
                .padding(.horizontal, KbSpacing.s3)
                .padding(.vertical, KbSpacing.s2)
                .background(
                    isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
                    in: shape
                )
                .kbTappable(in: shape) { if section.titleKey == nil { onIndex() } }
                .onHover { isHovered = section.titleKey == nil && $0 }
                .animation(KbMotion.quick, value: isHovered)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, KbSpacing.s5)
                .padding(.top, KbSpacing.s3)
            }
        }
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.sm, style: .continuous)
    }
}
