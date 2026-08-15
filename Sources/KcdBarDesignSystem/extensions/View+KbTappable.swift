import SwiftUI

extension View {
    /** Declares a hit area, the pointer that belongs to it, and what a click does. */
    package func kbTappable(
        in shape: some Shape,
        perform action: @escaping () -> Void
    ) -> some View {
        contentShape(shape)
            .pointerStyle(.link)
            .onTapGesture(perform: action)
    }

    /** The pointer alone, for a control that owns its own gesture. */
    package func kbClickable() -> some View {
        pointerStyle(.link)
    }
}
