import AppKit
import Foundation

/** Asks loginwindow to sleep, restart, shut down or log out, so macOS draws its own confirmation. */
@MainActor
package struct LoginWindowPowerControl: PowerActionPort {
    package init() {}

    package func perform(_ action: StartPowerAction) -> Bool {
        guard let event = PowerAppleEvent.identifier(for: action) else { return lockScreen() }

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

    private func lockScreen() -> Bool {
        let session = URL(fileURLWithPath: PowerActionMetrics.lockScreenToolPath)
        guard FileManager.default.isExecutableFile(atPath: session.path) else { return false }

        let process = Process()
        process.executableURL = session
        process.arguments = [PowerActionMetrics.lockScreenArgument]

        do {
            try process.run()

            return true
        } catch {
            return false
        }
    }
}
