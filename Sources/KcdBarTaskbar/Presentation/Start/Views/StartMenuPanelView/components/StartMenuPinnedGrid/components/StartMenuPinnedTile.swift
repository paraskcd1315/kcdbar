import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPinnedTile: View {
    package let app: PinnedApp
    package let icon: Image?
    package let onLaunch: () -> Void
    package let onUnpin: () -> Void

    @State private var isHovered = false

    package var body: some View {
        VStack(spacing: KbSpacing.s3) {
            StartMenuAppIcon(icon: icon, size: StartMenuMetrics.pinnedIconSize)
            Text(app.displayName)
                .font(KbTypography.entryTitle)
                .foregroundStyle(KbColors.onSurface)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding(StartMenuMetrics.pinnedTilePadding)
        .frame(maxWidth: .infinity)
        .frame(height: StartMenuMetrics.pinnedTileHeight)
        .background(
            isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
            in: shape
        )
        .kbTappable(in: shape, perform: onLaunch)
        .contextMenu { Button("start.unpin", action: onUnpin) }
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.md, style: .continuous)
    }
}
