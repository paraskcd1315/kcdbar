import Foundation
import IOBluetooth

private typealias SetControllerPowerStateFn = @convention(c) (Int32) -> Int32

/** Bluetooth power: the read is public, the write is a DisplayServices-style private symbol. */
@MainActor
struct IoBluetoothSource: BluetoothPort {
    private static let frameworkPath =
        "/System/Library/Frameworks/IOBluetooth.framework/Versions/A/IOBluetooth"

    private static let setPowerState: SetControllerPowerStateFn? = {
        guard let handle = dlopen(frameworkPath, RTLD_LAZY),
              let address = dlsym(handle, "IOBluetoothPreferenceSetControllerPowerState")
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

    func setPower(_ isOn: Bool) -> Bool {
        guard let setPowerState = Self.setPowerState else { return false }

        _ = setPowerState(isOn ? 1 : 0)

        return true
    }
}
