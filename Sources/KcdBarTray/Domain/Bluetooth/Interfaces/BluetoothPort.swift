@MainActor
package protocol BluetoothPort {
    func state() -> BluetoothState
    func devices() -> [BluetoothDevice]
    func setPower(_ isOn: Bool) -> Bool
}
