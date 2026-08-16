import Foundation

/** The loginwindow event each power action sends. */
package enum PowerAppleEvent {
    package static func identifier(for action: StartPowerAction) -> AEEventID? {
        switch action {
        case .sleep: code(PowerActionMetrics.sleepEvent)
        case .restart: code(PowerActionMetrics.showRestartDialogEvent)
        case .shutDown: code(PowerActionMetrics.showShutdownDialogEvent)
        case .lock: nil
        }
    }

    package static func code(_ text: String) -> AEEventID {
        text.utf8.reduce(0) { AEEventID($0) << 8 | AEEventID($1) }
    }
}
