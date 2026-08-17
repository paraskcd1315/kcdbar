import KcdBarDesignSystem
import SwiftUI

package struct StartMenuSectionHeading: View {
    package let title: LocalizedStringKey

    package var body: some View {
        Text(title)
            .font(KbTypography.menuHeading)
            .foregroundStyle(KbColors.onSurfaceMuted)
    }
}
