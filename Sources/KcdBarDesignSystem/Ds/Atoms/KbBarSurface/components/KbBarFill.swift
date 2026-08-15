import SwiftUI

struct KbBarFill<Content: View>: View {
    let material: BarMaterial
    let shape: AnyShape
    @ViewBuilder let content: () -> Content

    var body: some View {
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
