import Foundation

/** Whether an Accessibility window is one a user can switch to. */
package enum AxWindowClassification {
    package static func isSwitchable(_ record: AxWindowRecord) -> Bool {
        record.role == WindowMatchingMetrics.windowRole
            && WindowMatchingMetrics.switchableSubroles.contains(record.subrole ?? "")
    }
}
