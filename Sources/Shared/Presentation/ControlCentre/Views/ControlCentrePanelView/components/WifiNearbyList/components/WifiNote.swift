import SwiftUI

struct WifiNote: View {
    let titleKey: LocalizedStringKey

    var body: some View {
        Text(titleKey)
            .font(KbTypography.tileStatus)
            .foregroundStyle(KbColors.onSurfaceMuted)
            .padding(.horizontal, KbSpacing.s4)
            .padding(.vertical, KbSpacing.s2)
    }
}
