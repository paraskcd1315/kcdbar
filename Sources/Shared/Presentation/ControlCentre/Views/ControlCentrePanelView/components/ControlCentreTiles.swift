import SwiftUI

struct ControlCentreTiles: View {
    let wifi: WifiMonitor
    let bluetooth: BluetoothMonitor
    let sound: SoundMonitor
    let brightness: BrightnessMonitor
    let onExpandWifi: () -> Void

    var body: some View {
        GlassEffectContainer(spacing: KbControlCentreMetrics.tileGap) {
            VStack(spacing: KbControlCentreMetrics.tileGap) {
                SoundTile(monitor: sound)
                if brightness.state.isAvailable {
                    BrightnessTile(monitor: brightness)
                }
                HStack(alignment: .top, spacing: KbControlCentreMetrics.tileGap) {
                    WifiTile(monitor: wifi, onExpand: onExpandWifi)
                    BluetoothTile(monitor: bluetooth)
                }
            }
        }
    }
}
