struct BluetoothState: Equatable {
    let isAvailable: Bool
    let isPowered: Bool

    static let unavailable = BluetoothState(isAvailable: false, isPowered: false)
}
