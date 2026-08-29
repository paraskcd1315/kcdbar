// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import IOBluetooth

private typealias SetControllerPowerStateFn = @convention(c) (Int32) -> Int32

/** Bluetooth power: the read is public, the write is a DisplayServices-style private symbol. */
@MainActor
package struct IoBluetoothSource: BluetoothPort {
    package init() {}

    private static let setPowerState: SetControllerPowerStateFn? = {
        guard let handle = dlopen(TrayPrivateFrameworks.ioBluetooth, RTLD_LAZY),
              let address = dlsym(handle, TrayPrivateFrameworks.setControllerPowerState)
        else {
            return nil
        }
        return unsafeBitCast(address, to: SetControllerPowerStateFn.self)
    }()

    package func state() -> BluetoothState {
        guard let controller = IOBluetoothHostController.default() else { return .unavailable }

        return BluetoothState(
            isAvailable: Self.setPowerState != nil,
            isPowered: controller.powerState == kBluetoothHCIPowerStateON
        )
    }

    package func devices() -> [BluetoothDevice] {
        guard let paired = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
            return []
        }

        return BluetoothStyle.ordered(paired.compactMap(Self.device))
    }

    package func setPower(_ isOn: Bool) -> Bool {
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
