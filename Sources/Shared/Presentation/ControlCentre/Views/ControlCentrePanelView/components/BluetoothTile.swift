import SwiftUI

struct BluetoothTile: View {
    let monitor: BluetoothMonitor

    var body: some View {
        KbTile {
            ConnectivityRow(
                titleKey: "bluetooth.title",
                statusKey: ConnectivityLabels.bluetoothStatus(monitor.state),
                isOn: monitor.state.isPowered,
                onToggle: { monitor.setPower(!monitor.state.isPowered) },
                onOpen: nil
            ) {
                KbBluetoothMark(
                    size: KbControlCentreMetrics.rowGlyphSize * KbControlCentreMetrics.glyphRatio
                )
            }
        }
    }
}
