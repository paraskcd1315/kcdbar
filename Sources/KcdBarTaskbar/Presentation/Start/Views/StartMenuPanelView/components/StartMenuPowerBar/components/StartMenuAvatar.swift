import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAvatar: View {
    package let image: Image?

    package var body: some View {
        Group {
            if let image {
                image.resizable().interpolation(.high)
            } else {
                Image(systemName: StartMenuMetrics.avatarGlyph)
                    .resizable()
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: StartMenuMetrics.avatarSize, height: StartMenuMetrics.avatarSize)
        .clipShape(Circle())
        .overlay(Circle().stroke(KbColors.separator, lineWidth: KbEdgeMetrics.width))
    }
}
