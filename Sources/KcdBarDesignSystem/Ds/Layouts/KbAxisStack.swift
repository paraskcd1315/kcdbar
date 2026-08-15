import SwiftUI

/** Stacks its content along the given axis, keeping view identity when the axis changes. */
struct KbAxisStack<Content: View>: View {
    let isVertical: Bool
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content

    var body: some View {
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
