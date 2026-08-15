import KcdBarDesignSystem
import SwiftUI

package struct ControlCentreSurface: View {
    package let wifi: WifiMonitor
    package let bluetooth: BluetoothMonitor
    package let sound: SoundMonitor
    package let brightness: BrightnessMonitor
    @Binding package var isWifiExpanded: Bool
    package let onOpenSettings: () -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: KbControlCentreMetrics.tileGap) {
            if isWifiExpanded {
                KbTile {
                    WifiDetail(
                        monitor: wifi,
                        onBack: { withAnimation(KbMotion.standard) { isWifiExpanded = false } },
                        onOpenSettings: onOpenSettings
                    )
                }
            } else {
                ControlCentreTiles(
                    wifi: wifi,
                    bluetooth: bluetooth,
                    sound: sound,
                    brightness: brightness
                ) {
                    withAnimation(KbMotion.standard) { isWifiExpanded = true }
                }
            }
        }
        .padding(KbControlCentreMetrics.panelPadding)
        .frame(width: KbControlCentreMetrics.panelWidth, alignment: .leading)
        .animation(KbMotion.standard, value: isWifiExpanded)
    }
}
