enum BluetoothMetrics {
    static let onSymbol = "antenna.radiowaves.left.and.right"
    static let offSymbol = "antenna.radiowaves.left.and.right.slash"

    static func symbol(isPowered: Bool) -> String {
        isPowered ? onSymbol : offSymbol
    }
}
