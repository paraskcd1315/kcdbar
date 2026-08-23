import KcdBarDesignSystem
import SwiftUI

package struct SessionsPanelHeader: View {
    package let count: Int

    package init(count: Int) {
        self.count = count
    }

    package var body: some View {
        HStack {
            Text("sessions.title")
                .font(KbTypography.panelTitle)
                .foregroundStyle(KbColors.onSurface)
            Spacer(minLength: KbSpacing.s5)
            Text(verbatim: "\(count)")
                .font(KbTypography.panelTitle)
                .foregroundStyle(KbColors.brand)
                .monospacedDigit()
        }
    }
}
