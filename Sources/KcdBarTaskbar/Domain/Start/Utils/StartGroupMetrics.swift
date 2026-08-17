import Foundation

package enum StartGroupMetrics {
    package static let defaultGroupId = "pinned"
    package static let defaultGroupTitleKey = "start.group.pinned"
    package static let customPrefix = "custom."

    package static func freshId() -> String {
        customPrefix + UUID().uuidString
    }
}
