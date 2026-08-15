import Foundation
import SwiftData

/** One saved bar preset, held as its encoded form so a new axis needs no schema change. */
@Model
final class StoredPreset {
    @Attribute(.unique) var name: String
    var payload: Data
    var isBuiltIn: Bool

    init(name: String, payload: Data, isBuiltIn: Bool) {
        self.name = name
        self.payload = payload
        self.isBuiltIn = isBuiltIn
    }
}
