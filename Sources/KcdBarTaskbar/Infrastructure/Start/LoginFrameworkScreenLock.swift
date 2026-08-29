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

/** Locks the screen through login.framework, the route the system's own menu uses. */
@MainActor
package struct LoginFrameworkScreenLock: ScreenLockPort {
    private typealias LockScreenImmediate = @convention(c) () -> Void

    package init() {}

    package func lock() -> Bool {
        guard let handle = dlopen(PowerActionMetrics.loginFrameworkPath, RTLD_LAZY),
              let symbol = dlsym(handle, PowerActionMetrics.lockScreenSymbol)
        else {
            return false
        }
        unsafeBitCast(symbol, to: LockScreenImmediate.self)()

        return true
    }
}
