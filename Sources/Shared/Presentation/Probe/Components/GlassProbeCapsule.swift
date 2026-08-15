import SwiftUI

struct GlassProbeCapsule: View {
    let label: String

    var body: some View {
        Text(LocalizedStringKey(label))
            .font(KbTypography.probeLabel)
            .foregroundStyle(KbColors.onSurface)
            .padding(.horizontal, KbSpacing.s6)
            .padding(.vertical, KbSpacing.s4)
            .glassEffect(.regular.interactive(), in: .capsule)
    }
}
