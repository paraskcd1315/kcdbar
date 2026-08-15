import SwiftUI

/** Stacks its content along the given axis, keeping view identity when the axis changes. */
package struct KbAxisStack<Content: View>: View {
    package let isVertical: Bool
    package let spacing: CGFloat
    @ViewBuilder package let content: () -> Content

    package init(
        isVertical: Bool,
        spacing: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isVertical = isVertical
        self.spacing = spacing
        self.content = content
    }

    package var body: some View {
        layout {
            content()
        }
    }

    private var layout: AnyLayout {
        isVertical
            ? AnyLayout(VStackLayout(spacing: spacing))
            : AnyLayout(HStackLayout(spacing: spacing))
    }
}
