import Foundation
import SwiftData
import KcdBarBar

/** The Dock settings KCDBar found before it changed anything. */
@Model
package final class StoredDockSnapshot {
    @Attribute(.unique) package var id: String
    package var payload: Data

    package init(payload: Data) {
        self.id = StoredDockSnapshot.singletonKey
        self.payload = payload
    }

    package static let singletonKey = "dock-snapshot"
}
