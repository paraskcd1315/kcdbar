/** Bluetooth assigned-numbers class-of-device codes. */
enum BluetoothClassCodes {
    static let computer = 0x01
    static let phone = 0x02
    static let audio = 0x04
    static let peripheral = 0x05
    static let wearable = 0x07

    static let keyboard = 0x10
    static let pointing = 0x20

    static let powerOn: Int32 = 1
    static let powerOff: Int32 = 0
}
