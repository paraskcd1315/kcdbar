@MainActor
protocol BluetoothPort {
    func state() -> BluetoothState
    func setPower(_ isOn: Bool) -> Bool
}
