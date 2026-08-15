import Foundation
import IOBluetooth

private typealias SetControllerPowerStateFn = @convention(c) (Int32) -> Int32

/** Bluetooth power: the read is public, the write is a DisplayServices-style private symbol. */
@MainActor
struct IoBluetoothSource: BluetoothPort {
    private static let setPowerState: SetControllerPowerStateFn? = {
        guard let handle = dlopen(PrivateFrameworks.ioBluetooth, RTLD_LAZY),
              let address = dlsym(handle, PrivateFrameworks.bluetoothSetControllerPowerState)
        else {
            return nil
        }
        return unsafeBitCast(address, to: SetControllerPowerStateFn.self)
    }()

    func state() -> BluetoothState {
        guard let controller = IOBluetoothHostController.default() else { return .unavailable }

        return BluetoothState(
            isAvailable: Self.setPowerState != nil,
            isPowered: controller.powerState == kBluetoothHCIPowerStateON
        )
    }

    func devices() -> [BluetoothDevice] {
        guard let paired = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
            return []
        }

        return BluetoothStyle.ordered(paired.compactMap(Self.device))
    }

    func setPower(_ isOn: Bool) -> Bool {
        guard let setPowerState = Self.setPowerState else { return false }

        _ = setPowerState(isOn ? BluetoothClassCodes.powerOn : BluetoothClassCodes.powerOff)

        return true
    }

    private static func device(_ paired: IOBluetoothDevice) -> BluetoothDevice? {
        guard let address = paired.addressString, !address.isEmpty else { return nil }

        let name = paired.name ?? address

        return BluetoothDevice(
            id: address,
            name: name.isEmpty ? address : name,
            isConnected: paired.isConnected(),
            kind: BluetoothDeviceClassifier.kind(
                major: Int(paired.deviceClassMajor),
                minor: Int(paired.deviceClassMinor)
            )
        )
    }
}
