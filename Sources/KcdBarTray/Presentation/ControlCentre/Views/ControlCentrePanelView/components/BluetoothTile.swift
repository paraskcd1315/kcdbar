import KcdBarDesignSystem
import SwiftUI

package struct BluetoothTile: View {
    package let monitor: BluetoothMonitor
    package let onExpand: () -> Void

    package init(monitor: BluetoothMonitor, onExpand: @escaping () -> Void) {
        self.monitor = monitor
        self.onExpand = onExpand
    }

    package var body: some View {
        KbTile {
            ConnectivityRow(
                titleKey: "bluetooth.title",
                statusKey: ConnectivityLabels.bluetoothStatus(monitor.state),
                isOn: monitor.state.isPowered,
                onToggle: { monitor.setPower(!monitor.state.isPowered) },
                onOpen: onExpand
            ) {
                KbBluetoothMark(
                    size: KbControlCentreMetrics.rowGlyphSize * KbControlCentreMetrics.glyphRatio
                )
            }
        }
    }
}
