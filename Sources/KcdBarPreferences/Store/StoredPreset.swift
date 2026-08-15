import Foundation
import SwiftData
import KcdBarTaskbar

/** One saved bar preset, held as its encoded form so a new axis needs no schema change. */
@Model
package final class StoredPreset {
    @Attribute(.unique) package var name: String
    package var payload: Data
    package var isBuiltIn: Bool

    package init(name: String, payload: Data, isBuiltIn: Bool) {
        self.name = name
        self.payload = payload
        self.isBuiltIn = isBuiltIn
    }
}
