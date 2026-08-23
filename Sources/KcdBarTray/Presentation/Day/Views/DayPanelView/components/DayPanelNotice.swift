import KcdBarDesignSystem
import SwiftUI

package struct DayPanelNotice: View {
    package let message: LocalizedStringKey

    package init(message: LocalizedStringKey) {
        self.message = message
    }

    package var body: some View {
        Text(message)
            .font(KbTypography.panelDetail)
            .foregroundStyle(KbColors.onSurfaceMuted)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.vertical, KbSpacing.s7)
    }
}
