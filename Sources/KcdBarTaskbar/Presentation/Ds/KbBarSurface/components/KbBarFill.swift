import KcdBarDesignSystem
import SwiftUI

package struct KbBarFill<Content: View>: View {
    package let material: BarMaterial
    package let shape: AnyShape
    @ViewBuilder package let content: () -> Content

    package var body: some View {
        switch material {
        case .liquidGlass:
            content().glassEffect(.regular.interactive(), in: shape)
        case .vibrancy:
            content().background(KbVibrancyBackdrop().clipShape(shape))
        case .solid:
            content().background(KbColors.surface.clipShape(shape))
        }
    }
}
