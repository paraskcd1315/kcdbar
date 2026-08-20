import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTrash: View {
    package let monitor: TrashMonitor
    package let iconSize: CGFloat
    package let isVertical: Bool
    package let isFilled: Bool

    @State private var isHovered = false

    package init(
        monitor: TrashMonitor,
        iconSize: CGFloat = TrashMetrics.iconSize,
        isVertical: Bool = false,
        isFilled: Bool = false
    ) {
        self.monitor = monitor
        self.iconSize = iconSize
        self.isVertical = isVertical
        self.isFilled = isFilled
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
        .kbBarItem(isVertical: isVertical, isFilled: isFilled, isSquare: true, inset: TrashMetrics.glyphInset)
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
