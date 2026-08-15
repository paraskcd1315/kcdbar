import KcdBarDesignSystem
import SwiftUI

package struct NetworkDetailRow: View {
    package let field: NetworkDetailField
    package let onCopy: () -> Void

    @State private var isHovered = false
    @State private var hasCopied = false

    package var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: KbSpacing.s4) {
            Text(LocalizedStringKey(field.titleKey))
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .frame(width: KbControlCentreMetrics.detailLabelWidth, alignment: .leading)
            Text(field.value)
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: hasCopied ? NetworkDetailKeys.copiedSymbol : NetworkDetailKeys.copySymbol)
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .opacity(isHovered || hasCopied ? 1 : 0)
                .contentShape(Rectangle())
                .onTapGesture(perform: copy)
        }
        .padding(.horizontal, KbSpacing.s4)
        .padding(.vertical, KbSpacing.s2)
        .background(
            RoundedRectangle(cornerRadius: KbRadii.sm)
                .fill(isHovered ? KbColors.onSurface.opacity(KbControlCentreMetrics.hoverOpacity) : .clear)
        )
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
        .animation(KbMotion.quick, value: hasCopied)
    }

    private func copy() {
        onCopy()
        hasCopied = true
        Task {
            try? await Task.sleep(for: .seconds(KbControlCentreMetrics.copiedDuration))
            hasCopied = false
        }
    }
}
