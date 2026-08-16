import KcdBarDesignSystem
import SwiftUI

package struct StartMenuBandHeading: View {
    package let section: ApplicationSection
    package let isShowing: Bool

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
                .foregroundStyle(KbColors.onSurfaceMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, KbSpacing.s6)
                .padding(.top, KbSpacing.s3)
            }
        }
    }
}
