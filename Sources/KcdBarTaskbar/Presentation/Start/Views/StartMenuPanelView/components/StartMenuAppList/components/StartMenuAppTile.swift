import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAppTile: View {
    package let application: InstalledApplication
    package let icon: Image?
    package let isPinned: Bool
    package let onLaunch: () -> Void
    package let onTogglePin: () -> Void

    @State private var isHovered = false

    package var body: some View {
        VStack(spacing: KbSpacing.s3) {
            StartMenuAppIcon(icon: icon, size: StartMenuMetrics.gridIconSize)
            Text(application.displayName)
                .font(KbTypography.entryTitle)
                .foregroundStyle(KbColors.onSurface)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .truncationMode(.tail)
        }
        .padding(StartMenuMetrics.pinnedTilePadding)
        .frame(maxWidth: .infinity)
        .frame(height: StartMenuMetrics.gridTileHeight)
        .background(
            isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
            in: shape
        )
        .kbTappable(in: shape, perform: onLaunch)
        .contextMenu {
            Button(isPinned ? "start.unpin" : "start.pin", action: onTogglePin)
        }
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.md, style: .continuous)
    }
}
