import SwiftUI

struct ConnectivityTile: View {
    let wifi: WifiMonitor
    let bluetooth: BluetoothMonitor
    let onExpandWifi: () -> Void

    var body: some View {
        KbTile {
            VStack(spacing: 0) {
                ConnectivityRow(
                    symbol: BluetoothMetrics.symbol(isPowered: bluetooth.state.isPowered),
                    titleKey: "bluetooth.title",
                    statusKey: ConnectivityLabels.bluetoothStatus(bluetooth.state),
                    isOn: bluetooth.state.isPowered,
                    onToggle: { bluetooth.setPower(!bluetooth.state.isPowered) },
                    onOpen: nil
                )
                ConnectivityRow(
                    symbol: WifiStyle.symbol(for: wifi.state),
                    titleKey: "wifi.title",
                    statusKey: ConnectivityLabels.wifiStatus(wifi.state),
                    isOn: wifi.state.isPowered,
                    onToggle: { wifi.setPower(!wifi.state.isPowered) },
                    onOpen: onExpandWifi
                )
            }
        }
    }
}
