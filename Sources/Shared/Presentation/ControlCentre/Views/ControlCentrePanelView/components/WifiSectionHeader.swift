import SwiftUI

struct WifiSectionHeader: View {
    let titleKey: LocalizedStringKey
    let count: Int
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack {
            Text(titleKey)
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
            Spacer(minLength: KbSpacing.s3)
            Text("\(count)")
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .monospacedDigit()
            Image(systemName: WifiMetrics.chevronSymbol)
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .rotationEffect(.degrees(isExpanded ? 90 : 0))
        }
        .padding(.horizontal, KbSpacing.s4)
        .padding(.vertical, KbSpacing.s2)
        .background(.regularMaterial)
        .contentShape(Rectangle())
        .onTapGesture(perform: onToggle)
    }
}
