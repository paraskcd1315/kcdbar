import Observation

/** The control centre's live view of Bluetooth power and paired devices. */
@MainActor
@Observable
package final class BluetoothMonitor {
    package private(set) var state: BluetoothState = .unavailable
    package private(set) var devices: [BluetoothDevice] = []

    private let source: any BluetoothPort

    package init(source: any BluetoothPort) {
        self.source = source
    }

    package func refresh() {
        state = source.state()
        devices = state.isPowered ? source.devices() : []
    }

    package func setPower(_ isOn: Bool) {
        guard source.setPower(isOn) else { return }

        refresh()
    }
}
