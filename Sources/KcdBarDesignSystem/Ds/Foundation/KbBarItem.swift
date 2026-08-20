import SwiftUI

package struct KbBarItem: ViewModifier {
    package let isVertical: Bool
    package let isFilled: Bool
    package let isSquare: Bool
    package let inset: CGFloat

    package init(isVertical: Bool, isFilled: Bool, isSquare: Bool, inset: CGFloat) {
        self.isVertical = isVertical
        self.isFilled = isFilled
        self.isSquare = isSquare
        self.inset = inset
    }

    package func body(content: Content) -> some View {
        content
            .padding(isSquare ? .all : .horizontal, isSquare && isFilled ? 0 : inset)
            .frame(
                maxWidth: isFilled && isVertical ? .infinity : nil,
                maxHeight: isFilled && !isVertical ? .infinity : nil
            )
            .aspectRatio(isSquare ? 1 : nil, contentMode: .fit)
    }
}

extension View {
    package func kbBarItem(
        isVertical: Bool,
        isFilled: Bool,
        isSquare: Bool,
        inset: CGFloat = KbSpacing.s3
    ) -> some View {
        modifier(KbBarItem(isVertical: isVertical, isFilled: isFilled, isSquare: isSquare, inset: inset))
    }
}
