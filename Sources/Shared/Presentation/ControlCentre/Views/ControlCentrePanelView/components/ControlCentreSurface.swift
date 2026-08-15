import SwiftUI

struct ControlCentreSurface: View {
    let wifi: WifiMonitor
    let bluetooth: BluetoothMonitor
    let sound: SoundMonitor
    let brightness: BrightnessMonitor
    @Binding var isWifiExpanded: Bool
    let onOpenSettings: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s4) {
            if isWifiExpanded {
                WifiDetail(monitor: wifi, onOpenSettings: onOpenSettings)
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
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: nil))
        .overlay { KbPopoverEdge(arrowX: nil) }
        .animation(KbMotion.standard, value: isWifiExpanded)
    }
}
