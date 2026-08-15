import Observation

/** The control centre's live view of Bluetooth power. */
@MainActor
@Observable
final class BluetoothMonitor {
    private(set) var state: BluetoothState = .unavailable

    private let source: any BluetoothPort

    init(source: any BluetoothPort) {
        self.source = source
    }

    func refresh() {
        state = source.state()
    }

    func setPower(_ isOn: Bool) {
        guard source.setPower(isOn) else { return }

        refresh()
    }
}
