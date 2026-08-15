import Testing

struct BluetoothDeviceClassifierTests {
    @Test func headphonesReadAsAudio() {
        #expect(BluetoothDeviceClassifier.kind(major: 0x04, minor: 0) == .audio)
    }

    @Test func aPhoneReadsAsAPhone() {
        #expect(BluetoothDeviceClassifier.kind(major: 0x02, minor: 0) == .phone)
    }

    @Test func peripheralsSplitByTheirMinorClass() {
        #expect(BluetoothDeviceClassifier.kind(major: 0x05, minor: 0x10) == .keyboard)
        #expect(BluetoothDeviceClassifier.kind(major: 0x05, minor: 0x20) == .pointing)
        #expect(BluetoothDeviceClassifier.kind(major: 0x05, minor: 0x30) == .other)
    }

    @Test func anUnknownClassIsOther() {
        #expect(BluetoothDeviceClassifier.kind(major: 0x1F, minor: 0) == .other)
    }
}
