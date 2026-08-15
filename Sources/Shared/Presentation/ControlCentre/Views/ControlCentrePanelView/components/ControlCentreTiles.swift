import SwiftUI

struct ControlCentreTiles: View {
    let wifi: WifiMonitor
    let bluetooth: BluetoothMonitor
    let sound: SoundMonitor
    let brightness: BrightnessMonitor
    let onExpandWifi: () -> Void

    var body: some View {
        VStack(spacing: KbControlCentreMetrics.tileGap) {
            SoundTile(monitor: sound)
            if brightness.state.isAvailable {
                BrightnessTile(monitor: brightness)
            }
            ConnectivityTile(wifi: wifi, bluetooth: bluetooth, onExpandWifi: onExpandWifi)
        }
    }
}
