import SwiftUI

extension View {
    /** Declares a hit area and what a click inside it does. */
    package func kbTappable(
        in shape: some Shape,
        perform action: @escaping () -> Void
    ) -> some View {
        contentShape(shape)
            .onTapGesture(perform: action)
    }
}
