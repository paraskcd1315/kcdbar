import Foundation
import SwiftData

/** How often an application was launched, so the Start menu can offer the ones reached for most. */
@Model
package final class StoredApplicationUsage {
    @Attribute(.unique) package var bundleIdentifier: String
    package var count: Int
    package var lastLaunchedAt: Date

    package init(bundleIdentifier: String, count: Int, lastLaunchedAt: Date) {
        self.bundleIdentifier = bundleIdentifier
        self.count = count
        self.lastLaunchedAt = lastLaunchedAt
    }
}
