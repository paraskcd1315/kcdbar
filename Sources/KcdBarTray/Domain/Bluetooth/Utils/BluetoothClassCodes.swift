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

/** Bluetooth assigned-numbers class-of-device codes. */
package enum BluetoothClassCodes {
    package static let computer = 0x01
    package static let phone = 0x02
    package static let audio = 0x04
    package static let peripheral = 0x05
    package static let wearable = 0x07

    package static let keyboard = 0x10
    package static let pointing = 0x20

    package static let powerOn: Int32 = 1
    package static let powerOff: Int32 = 0
}
