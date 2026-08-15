import SwiftUI

package struct ControlCentreTiles: View {
    package let wifi: WifiMonitor
    package let bluetooth: BluetoothMonitor
    package let sound: SoundMonitor
    package let brightness: BrightnessMonitor
    package let onExpandWifi: () -> Void

    package var body: some View {
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
