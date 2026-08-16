import SwiftUI

package struct StartMenuIndexOverlay: View {
    package let isShowing: Bool
    package let availableKeys: Set<String>
    package let onJump: (String) -> Void
    package let onDismiss: () -> Void

    package var body: some View {
        ZStack {
            if isShowing {
                StartMenuLetterGrid(
                    keys: ApplicationIndexKeys.all,
                    available: availableKeys,
                    onSelect: onJump,
                    onDismiss: onDismiss
                )
            }
        }
    }
}
