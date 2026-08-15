import KcdBarDesignSystem
import SwiftUI

package struct TaskbarShowDesktopButton: View {
    package let isShowingDesktop: Bool
    package let shape: AnyShape
    package let onToggle: () -> Void

    @State private var isHovered = false

    package var body: some View {
        Rectangle()
            .fill(.clear)
            .frame(width: TaskbarMetrics.showDesktopWidth)
            .frame(maxHeight: .infinity)
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(KbColors.separator)
                    .frame(width: TaskbarMetrics.showDesktopDividerWidth)
            }
            .contentShape(shape)
            .onTapGesture(perform: onToggle)
            .glassEffect(isHovered || isShowingDesktop ? .regular.interactive() : .identity, in: shape)
            .animation(KbMotion.quick, value: isHovered)
            .animation(KbMotion.quick, value: isShowingDesktop)
            .onHover { isHovered = $0 }
    }
}
