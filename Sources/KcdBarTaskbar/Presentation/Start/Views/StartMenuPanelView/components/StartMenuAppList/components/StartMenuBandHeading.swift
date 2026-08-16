import KcdBarDesignSystem
import SwiftUI

package struct StartMenuBandHeading: View {
    package let section: ApplicationSection

    package var body: some View {
        Group {
            if let titleKey = section.titleKey {
                Text(LocalizedStringKey(titleKey))
            } else {
                Text(section.key)
            }
        }
        .font(KbTypography.panelDetail)
        .foregroundStyle(KbColors.onSurfaceMuted)
        .padding(.horizontal, KbSpacing.s6)
        .padding(.top, KbSpacing.s3)
    }
}
