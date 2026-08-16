import KcdBarDesignSystem
import SwiftUI

package struct StartMenuListHeading: View {
    package let opened: ApplicationSection?
    package let onBack: () -> Void

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            if let opened {
                Image(systemName: StartMenuMetrics.backGlyph)
                    .font(KbTypography.menuHeading)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                StartMenuSectionHeading(title: LocalizedStringKey(opened.titleKey ?? opened.key))
            } else {
                StartMenuSectionHeading(title: "start.all")
            }
            Spacer(minLength: 0)
        }
        .contentShape(Rectangle())
        .onTapGesture { if opened != nil { onBack() } }
        .padding(.horizontal, KbSpacing.s6)
    }
}
