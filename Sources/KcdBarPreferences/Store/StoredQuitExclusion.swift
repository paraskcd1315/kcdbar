import Foundation
import SwiftData

/** An application the user keeps running after its last window closes. */
@Model
package final class StoredQuitExclusion {
    @Attribute(.unique) package var bundleIdentifier: String
    package var displayName: String

    package init(bundleIdentifier: String, displayName: String) {
        self.bundleIdentifier = bundleIdentifier
        self.displayName = displayName
    }
}
