import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPowerBar: View {
    package let userName: String
    package let avatar: Image?
    package let onPower: (StartPowerAction) -> Void

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            StartMenuAccountMenu(userName: userName, avatar: avatar, onPower: onPower)
            Spacer(minLength: KbSpacing.s4)
            ForEach(StartPowerAction.barActions) { action in
                StartMenuPowerButton(action: action, onPower: { onPower(action) })
            }
        }
    }
}
