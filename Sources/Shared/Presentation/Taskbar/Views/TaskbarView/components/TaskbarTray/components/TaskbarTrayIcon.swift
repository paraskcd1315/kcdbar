import SwiftUI

struct TaskbarTrayIcon: View {
    let item: TrayItemModel
    let onPress: () -> Void

    @State private var isHovered = false

    var body: some View {
        Group {
            if let icon = item.icon {
                icon
                    .renderingMode(item.isGlyph ? .template : .original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(KbColors.onSurface)
            } else {
                Circle().fill(KbColors.onSurfaceMuted)
            }
        }
        .frame(width: TrayMetrics.iconSize, height: TrayMetrics.iconSize)
        .padding(KbSpacing.s2)
        .contentShape(shape)
        .onTapGesture(perform: onPress)
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: shape)
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
        .help(item.label ?? item.applicationName)
    }

    private var shape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.sm))
    }
}
