import Foundation
import SwiftData

/** An application the user keeps in the bar whether or not it has a window open. */
@Model
final class StoredPinnedApp {
    @Attribute(.unique) var bundleIdentifier: String
    var order: Int
    var displayName: String

    init(bundleIdentifier: String, order: Int, displayName: String) {
        self.bundleIdentifier = bundleIdentifier
        self.order = order
        self.displayName = displayName
    }
}
