struct BluetoothDevice: Identifiable, Equatable {
    let id: String
    let name: String
    let isConnected: Bool
    let kind: BluetoothDeviceKind
}
