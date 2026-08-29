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

private typealias CoreDockSendNotificationFn =
    @convention(c) (CFString, UnsafeMutableRawPointer?) -> Void

/** The system's own Show Desktop, reached through Dock's notification entry point. */
@MainActor
package struct CoreDockShowDesktop: ShowDesktopPort {
    package init() {}

    private static let send: CoreDockSendNotificationFn? = {
        guard let handle = dlopen(PrivateFrameworks.applicationServices, RTLD_LAZY),
              let symbol = dlsym(handle, PrivateFrameworks.coreDockSendNotification)
        else {
            return nil
        }
        return unsafeBitCast(symbol, to: CoreDockSendNotificationFn.self)
    }()

    package var isAvailable: Bool { Self.send != nil }

    package func toggle() -> Bool {
        guard let send = Self.send else { return false }

        send(PrivateFrameworks.showDesktopNotification as CFString, nil)

        return true
    }
}
