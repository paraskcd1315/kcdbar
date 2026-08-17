import SwiftUI

package struct StartMenuAppIcon: View {
    package let icon: Image?
    package let size: CGFloat

    package var body: some View {
        Group {
            if let icon {
                icon.resizable().interpolation(.high)
            } else {
                Image(systemName: StartMenuMetrics.placeholderGlyph).resizable()
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(width: size, height: size)
    }
}
