import SwiftUI

struct WifiToggle: View {
    let isOn: Bool
    let onToggle: (Bool) -> Void

    var body: some View {
        Capsule()
            .fill(isOn ? KbColors.brand : KbColors.surfaceRaised)
            .frame(width: KbControlCentreMetrics.toggleWidth, height: KbControlCentreMetrics.toggleHeight)
            .overlay(alignment: isOn ? .trailing : .leading) {
                Circle()
                    .fill(KbColors.onBrand)
                    .padding(KbControlCentreMetrics.knobInset)
            }
            .contentShape(Capsule())
            .onTapGesture { onToggle(!isOn) }
            .animation(KbMotion.quick, value: isOn)
    }
}
