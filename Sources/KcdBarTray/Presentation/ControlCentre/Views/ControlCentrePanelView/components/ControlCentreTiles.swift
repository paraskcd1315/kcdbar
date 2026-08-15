import KcdBarDesignSystem
import SwiftUI

package struct ControlCentreTiles: View {
    package let wifi: WifiMonitor
    package let bluetooth: BluetoothMonitor
    package let sound: SoundMonitor
    package let brightness: BrightnessMonitor
    package let onOpen: (ControlCentrePage) -> Void
    package let onOpenNetworkSettings: () -> Void

    package var body: some View {
        GlassEffectContainer(spacing: KbControlCentreMetrics.tileGap) {
            VStack(spacing: KbControlCentreMetrics.tileGap) {
                SoundTile(monitor: sound)
                if brightness.state.isAvailable {
                    BrightnessTile(monitor: brightness)
                }
                HStack(alignment: .top, spacing: KbControlCentreMetrics.tileGap) {
                    if case let .ethernet(name) = wifi.link {
                        EthernetTile(name: name, onOpenSettings: onOpenNetworkSettings)
                    } else {
                        WifiTile(monitor: wifi) { onOpen(.wifi) }
                    }
                    BluetoothTile(monitor: bluetooth) { onOpen(.bluetooth) }
                }
            }
        }
    }
}
