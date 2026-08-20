import SwiftUI

package struct KbBarItem: ViewModifier {
    package let isVertical: Bool
    package let side: CGFloat?
    package let inset: CGFloat

    package init(isVertical: Bool, side: CGFloat?, inset: CGFloat) {
        self.isVertical = isVertical
        self.side = side
        self.inset = inset
    }

    package func body(content: Content) -> some View {
        if let side {
            content.frame(width: side, height: side)
        } else {
            content
                .padding(.horizontal, inset)
                .frame(
                    maxWidth: isVertical ? .infinity : nil,
                    maxHeight: isVertical ? nil : .infinity
                )
        }
    }
}

extension View {
    package func kbBarItem(
        isVertical: Bool,
        side: CGFloat?,
        inset: CGFloat = KbSpacing.s4
    ) -> some View {
        modifier(KbBarItem(isVertical: isVertical, side: side, inset: inset))
    }
}
