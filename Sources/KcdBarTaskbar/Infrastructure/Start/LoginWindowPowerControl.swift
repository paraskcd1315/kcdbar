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
