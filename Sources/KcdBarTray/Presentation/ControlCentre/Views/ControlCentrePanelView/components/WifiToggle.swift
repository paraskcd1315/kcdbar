import KcdBarDesignSystem
import SwiftUI

package struct WifiToggle: View {
    package let isOn: Bool
    package let onToggle: (Bool) -> Void

    package var body: some View {
        Capsule()
            .fill(isOn ? KbColors.brand : KbColors.surfaceRaised)
            .frame(width: KbControlCentreMetrics.toggleWidth, height: KbControlCentreMetrics.toggleHeight)
            .overlay(alignment: isOn ? .trailing : .leading) {
                Circle()
                    .fill(KbColors.onBrand)
                    .padding(KbControlCentreMetrics.knobInset)
            }
            .kbTappable(in: Capsule()) { onToggle(!isOn) }
            .animation(KbMotion.quick, value: isOn)
    }
}
