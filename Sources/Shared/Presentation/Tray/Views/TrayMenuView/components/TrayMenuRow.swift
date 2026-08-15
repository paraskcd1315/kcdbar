import SwiftUI

struct TrayMenuRow: View {
    let entry: MenuBarEntry
    let onSelect: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: KbSpacing.s2) {
            Text(entry.title)
                .font(KbTypography.entryTitle)
                .foregroundStyle(entry.isEnabled ? KbColors.onSurface : KbColors.onSurfaceMuted)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: 0)
            if entry.hasSubmenu {
                Image(systemName: "chevron.right")
                    .font(KbTypography.entryTitle)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
        }
        .padding(.horizontal, KbSpacing.s4)
        .padding(.vertical, KbSpacing.s2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .background(rowBackground)
        .onHover { isHovered = $0 }
        .onTapGesture { if entry.isEnabled { onSelect() } }
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: KbRadii.sm)
            .fill(isHovered && entry.isEnabled ? KbColors.activeIndicator.opacity(0.30) : .clear)
    }
}
