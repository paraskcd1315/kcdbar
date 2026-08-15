import Foundation

enum BluetoothStyle {
    static func symbol(for kind: BluetoothDeviceKind) -> String {
        switch kind {
        case .audio: BluetoothMetrics.audioSymbol
        case .phone: BluetoothMetrics.phoneSymbol
        case .computer: BluetoothMetrics.computerSymbol
        case .keyboard: BluetoothMetrics.keyboardSymbol
        case .pointing: BluetoothMetrics.pointingSymbol
        case .wearable: BluetoothMetrics.wearableSymbol
        case .other: BluetoothMetrics.otherSymbol
        }
    }

    static func ordered(_ devices: [BluetoothDevice]) -> [BluetoothDevice] {
        devices.sorted { first, second in
            guard first.isConnected == second.isConnected else { return first.isConnected }

            return first.name.localizedCaseInsensitiveCompare(second.name) == .orderedAscending
        }
    }
}
