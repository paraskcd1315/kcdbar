import SwiftUI

struct GlassProbeSwatch: View {
    var body: some View {
        Image(systemName: "square.on.square.badge.person.crop")
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(KbColors.onSurface)
            .padding(KbSpacing.s5)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: KbRadii.lg))
    }
}
