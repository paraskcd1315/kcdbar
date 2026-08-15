package struct BluetoothState: Equatable {
    package let isAvailable: Bool
    package let isPowered: Bool

    package static let unavailable = BluetoothState(isAvailable: false, isPowered: false)
}
