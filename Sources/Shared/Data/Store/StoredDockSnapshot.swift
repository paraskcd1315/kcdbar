import Foundation
import SwiftData

/** The Dock settings KCDBar found before it changed anything. */
@Model
final class StoredDockSnapshot {
    @Attribute(.unique) var id: String
    var payload: Data

    init(payload: Data) {
        self.id = StoredDockSnapshot.singletonKey
        self.payload = payload
    }

    static let singletonKey = "dock-snapshot"
}
