import SwiftUI

extension View {
    /** Declares a hit area, the pointer that belongs to it, and what a click does. */
    package func kbTappable(
        in shape: some Shape,
        perform action: @escaping () -> Void
    ) -> some View {
        contentShape(shape)
            .kbClickable()
            .onTapGesture(perform: action)
    }

    /** The pointer alone, for a control that owns its own gesture. */
    package func kbClickable() -> some View {
        modifier(KbClickable())
    }
}

private struct KbClickable: ViewModifier {
    @Environment(\.pointerCatcher) private var pointerCatcher

    func body(content: Content) -> some View {
        content.onContinuousHover { phase in
            switch phase {
            case .active: pointerCatcher(true)
            case .ended: pointerCatcher(false)
            }
        }
    }
}
