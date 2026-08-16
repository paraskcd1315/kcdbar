import Foundation
import SwiftData

/** An application the user keeps in the Start menu, which is a separate list from the bar's. */
@Model
package final class StoredStartPin {
    @Attribute(.unique) package var bundleIdentifier: String
    package var order: Int
    package var displayName: String

    package init(bundleIdentifier: String, order: Int, displayName: String) {
        self.bundleIdentifier = bundleIdentifier
        self.order = order
        self.displayName = displayName
    }
}
