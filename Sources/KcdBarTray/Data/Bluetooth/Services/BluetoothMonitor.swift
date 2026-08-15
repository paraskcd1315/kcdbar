import Observation

/** The control centre's live view of Bluetooth power and paired devices. */
@MainActor
@Observable
final class BluetoothMonitor {
    private(set) var state: BluetoothState = .unavailable
    private(set) var devices: [BluetoothDevice] = []

    private let source: any BluetoothPort

    init(source: any BluetoothPort) {
        self.source = source
    }

    func refresh() {
        state = source.state()
        devices = state.isPowered ? source.devices() : []
    }

    func setPower(_ isOn: Bool) {
        guard source.setPower(isOn) else { return }

        refresh()
    }
}
