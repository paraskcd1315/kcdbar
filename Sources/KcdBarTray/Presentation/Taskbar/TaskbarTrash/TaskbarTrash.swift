import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTrash: View {
    package let monitor: TrashMonitor
    package let iconSize: CGFloat

    @State private var isHovered = false

    package init(monitor: TrashMonitor, iconSize: CGFloat = TrashMetrics.iconSize) {
        self.monitor = monitor
        self.iconSize = iconSize
    }

    package var body: some View {
        Group {
            if let icon = monitor.icon {
                icon
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: TrashSymbols.fallback(isEmpty: monitor.state.isEmpty))
                    .foregroundStyle(KbColors.onSurface)
            }
        }
        .frame(width: iconSize, height: iconSize)
        .padding(TrashMetrics.glyphInset)
        .kbTappable(in: shape) { monitor.open() }
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: shape)
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
        .contextMenu {
            TaskbarTrashMenu(
                isEmpty: monitor.state.isEmpty,
                onOpen: { monitor.open() },
                onEmpty: { monitor.empty() }
            )
        }
    }

    private var shape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.sm))
    }
}
