import AppKit
import os

/** Sets the pointing hand, and logs whether the hover ever reaches it. */
@MainActor
package enum AppKitPointer {
    package static func set(isInside: Bool) {
        trace.notice("pointer inside=\(isInside, privacy: .public)")

        if isInside {
            NSCursor.pointingHand.set()
        } else {
            NSCursor.arrow.set()
        }
    }

    private static let trace = Logger(subsystem: "com.paraskcd.kcdbar", category: "pointer")
}
