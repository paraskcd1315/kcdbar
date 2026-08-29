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

import AppKit
import Foundation

/** Asks loginwindow to sleep, restart, shut down or log out, so macOS draws its own confirmation. */
@MainActor
package struct LoginWindowPowerControl: PowerActionPort {
    private let screenLock: any ScreenLockPort

    package init(screenLock: any ScreenLockPort = LoginFrameworkScreenLock()) {
        self.screenLock = screenLock
    }

    package func perform(_ action: StartPowerAction) -> Bool {
        guard let event = PowerAppleEvent.identifier(for: action) else { return screenLock.lock() }

        return send(event)
    }

    private func send(_ eventId: AEEventID) -> Bool {
        let target = NSAppleEventDescriptor(
            bundleIdentifier: PowerActionMetrics.loginWindowBundleIdentifier
        )
        let event = NSAppleEventDescriptor(
            eventClass: AEEventClass(kCoreEventClass),
            eventID: eventId,
            targetDescriptor: target,
            returnID: AEReturnID(kAutoGenerateReturnID),
            transactionID: AETransactionID(kAnyTransactionID)
        )

        do {
            try event.sendEvent(options: .noReply, timeout: PowerActionMetrics.eventTimeout)

            return true
        } catch {
            return false
        }
    }

}
