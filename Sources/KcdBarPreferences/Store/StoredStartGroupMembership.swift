import Foundation
import SwiftData

/** Which band a pinned application belongs to, kept apart from the pin so old pins survive. */
@Model
package final class StoredStartGroupMembership {
    @Attribute(.unique) package var bundleIdentifier: String
    package var groupId: String
    package var order: Int

    package init(bundleIdentifier: String, groupId: String, order: Int) {
        self.bundleIdentifier = bundleIdentifier
        self.groupId = groupId
        self.order = order
    }
}
