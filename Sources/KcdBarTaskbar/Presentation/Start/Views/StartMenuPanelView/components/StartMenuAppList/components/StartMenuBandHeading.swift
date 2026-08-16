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
                HStack(spacing: 0) {
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
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, KbSpacing.s5)
                .padding(.top, KbSpacing.s3)
                .contentShape(Rectangle())
                .onTapGesture { if isIndexable { onIndex() } }
                .onHover { isHovered = isIndexable && $0 }
                .animation(KbMotion.quick, value: isHovered)
            }
        }
    }

    private var isIndexable: Bool {
        section.titleKey == nil
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.sm, style: .continuous)
    }
}
