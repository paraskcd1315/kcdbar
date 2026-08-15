import SwiftUI

struct TaskbarTooltip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(KbTypography.entryTitle)
            .foregroundStyle(KbColors.onSurface)
            .lineLimit(1)
            .padding(.horizontal, KbSpacing.s4)
            .padding(.vertical, KbSpacing.s2)
            .glassEffect(.regular, in: .capsule)
            .fixedSize()
            .allowsHitTesting(false)
    }
}
