import KcdBarDesignSystem
import SwiftUI

package struct WifiNote: View {
    package let titleKey: LocalizedStringKey

    package var body: some View {
        Text(titleKey)
            .font(KbTypography.tileStatus)
            .foregroundStyle(KbColors.onSurfaceMuted)
            .padding(.horizontal, KbSpacing.s4)
            .padding(.vertical, KbSpacing.s2)
    }
}
