import SwiftUI

struct TaskbarControlCentreButton: View {
    let onOpen: () -> Void

    @State private var isHovered = false

    var body: some View {
        Image(systemName: "switch.2")
            .font(KbTypography.controlCentreGlyph)
            .foregroundStyle(KbColors.onSurface)
            .frame(width: TaskbarMetrics.controlCentreWidth)
            .padding(.vertical, KbSpacing.s2)
            .contentShape(shape)
            .onTapGesture(perform: onOpen)
            .glassEffect(isHovered ? .regular.interactive() : .identity, in: shape)
            .animation(KbMotion.quick, value: isHovered)
            .onHover { isHovered = $0 }
    }

    private var shape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.sm))
    }
}
