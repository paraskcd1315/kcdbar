package struct BluetoothDevice: Identifiable, Equatable {
    package let id: String
    package let name: String
    package let isConnected: Bool
    package let kind: BluetoothDeviceKind
}
