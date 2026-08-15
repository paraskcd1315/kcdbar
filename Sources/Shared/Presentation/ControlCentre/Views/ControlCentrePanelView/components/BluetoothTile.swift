import SwiftUI

struct BluetoothTile: View {
    let monitor: BluetoothMonitor

    var body: some View {
        KbTile {
            ConnectivityRow(
                symbol: BluetoothMetrics.symbol(isPowered: monitor.state.isPowered),
                titleKey: "bluetooth.title",
                statusKey: ConnectivityLabels.bluetoothStatus(monitor.state),
                isOn: monitor.state.isPowered,
                onToggle: { monitor.setPower(!monitor.state.isPowered) },
                onOpen: nil
            )
        }
    }
}
