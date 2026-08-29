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

/** The 20-byte token HIServices turns into another process's element — pid, zero, `coco`, element id. */
package enum AxRemoteToken {
    package static func data(pid: pid_t, elementId: UInt64) -> Data {
        var token = Data()
        token.append(bytes(of: Int32(pid)))
        token.append(bytes(of: Int32(0)))
        token.append(bytes(of: PrivateFrameworks.axRemoteTokenMagic))
        token.append(bytes(of: elementId))
        return token
    }

    private static func bytes<Value>(of value: Value) -> Data {
        withUnsafeBytes(of: value) { Data($0) }
    }
}
