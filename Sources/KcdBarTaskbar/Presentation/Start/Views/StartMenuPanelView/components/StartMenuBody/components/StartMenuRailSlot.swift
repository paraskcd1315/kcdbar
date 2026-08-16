import SwiftUI

package struct StartMenuRailSlot: View {
    package let isShowing: Bool
    package let availableKeys: Set<String>
    package let onJump: (String) -> Void

    package var body: some View {
        ZStack {
            if isShowing {
                StartMenuIndexRail(
                    keys: ApplicationIndexKeys.all,
                    available: availableKeys,
                    onSelect: onJump
                )
            }
        }
    }
}
