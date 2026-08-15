/** Maps a Bluetooth class-of-device to the kind the control centre draws. */
enum BluetoothDeviceClassifier {
    static func kind(major: Int, minor: Int) -> BluetoothDeviceKind {
        switch major {
        case BluetoothClassCodes.audio: .audio
        case BluetoothClassCodes.phone: .phone
        case BluetoothClassCodes.computer: .computer
        case BluetoothClassCodes.wearable: .wearable
        case BluetoothClassCodes.peripheral: peripheral(minor: minor)
        default: .other
        }
    }

    private static func peripheral(minor: Int) -> BluetoothDeviceKind {
        switch minor {
        case BluetoothClassCodes.keyboard: .keyboard
        case BluetoothClassCodes.pointing: .pointing
        default: .other
        }
    }
}
