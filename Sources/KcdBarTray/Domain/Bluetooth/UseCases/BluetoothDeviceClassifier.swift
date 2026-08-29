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

/** Maps a Bluetooth class-of-device to the kind the control centre draws. */
package enum BluetoothDeviceClassifier {
    package static func kind(major: Int, minor: Int) -> BluetoothDeviceKind {
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
