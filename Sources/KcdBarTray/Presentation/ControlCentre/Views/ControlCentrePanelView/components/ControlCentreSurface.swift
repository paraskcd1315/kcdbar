import SwiftUI

struct ControlCentreSurface: View {
    let wifi: WifiMonitor
    let bluetooth: BluetoothMonitor
    let sound: SoundMonitor
    let brightness: BrightnessMonitor
    @Binding var isWifiExpanded: Bool
    let onOpenSettings: () -> Void

    var body: some View {
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
