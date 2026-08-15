import Foundation
import SwiftData
import KcdBarTaskbar

/** An application the user keeps in the bar whether or not it has a window open. */
@Model
package final class StoredPinnedApp {
    @Attribute(.unique) package var bundleIdentifier: String
    package var order: Int
    package var displayName: String

    package init(bundleIdentifier: String, order: Int, displayName: String) {
        self.bundleIdentifier = bundleIdentifier
        self.order = order
        self.displayName = displayName
    }
}
