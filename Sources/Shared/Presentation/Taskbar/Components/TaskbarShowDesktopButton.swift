import SwiftUI

struct TaskbarShowDesktopButton: View {
    let isShowingDesktop: Bool
    let onToggle: () -> Void

    @State private var isHovered = false

    var body: some View {
        Rectangle()
            .fill(.clear)
            .frame(width: TaskbarMetrics.showDesktopWidth)
            .frame(maxHeight: .infinity)
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(KbColors.separator)
                    .frame(width: TaskbarMetrics.showDesktopDividerWidth)
            }
            .contentShape(.rect)
            .onTapGesture(perform: onToggle)
            .glassEffect(isHovered || isShowingDesktop ? .regular.interactive() : .identity, in: .rect(cornerRadius: KbRadii.md))
            .animation(KbMotion.quick, value: isHovered)
            .animation(KbMotion.quick, value: isShowingDesktop)
            .onHover { isHovered = $0 }
    }
}
