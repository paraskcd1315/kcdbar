import KcdBarDesignSystem
import SwiftUI

package struct ControlCentreSurface: View {
    package let wifi: WifiMonitor
    package let bluetooth: BluetoothMonitor
    package let sound: SoundMonitor
    package let brightness: BrightnessMonitor
    @Binding package var page: ControlCentrePage
    package let onOpenWifiSettings: () -> Void
    package let onOpenBluetoothSettings: () -> Void
    package let onOpenNetworkSettings: () -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: KbControlCentreMetrics.tileGap) {
            switch page {
            case .tiles:
                ControlCentreTiles(
                    wifi: wifi,
                    bluetooth: bluetooth,
                    sound: sound,
                    brightness: brightness,
                    onOpen: { show($0) },
                    onOpenNetworkSettings: onOpenNetworkSettings
                )
            case .wifi:
                KbTile {
                    WifiDetail(
                        monitor: wifi,
                        onBack: { show(.tiles) },
                        onOpenSettings: onOpenWifiSettings
                    )
                }
            case .bluetooth:
                KbTile {
                    BluetoothDetail(
                        monitor: bluetooth,
                        onBack: { show(.tiles) },
                        onOpenSettings: onOpenBluetoothSettings
                    )
                }
            }
        }
        .padding(KbControlCentreMetrics.panelPadding)
        .frame(width: KbControlCentreMetrics.panelWidth, alignment: .leading)
        .animation(KbMotion.standard, value: page)
    }

    private func show(_ wanted: ControlCentrePage) {
        withAnimation(KbMotion.standard) { page = wanted }
    }
}
