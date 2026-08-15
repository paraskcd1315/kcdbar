import Foundation
import SwiftData

/** The one row holding what the app remembers between launches. */
@Model
final class StoredPreferences {
    @Attribute(.unique) var id: String
    var activePresetName: String
    var hasCompletedOnboarding: Bool

    init(activePresetName: String, hasCompletedOnboarding: Bool) {
        self.id = StoredPreferences.singletonKey
        self.activePresetName = activePresetName
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }

    static let singletonKey = "preferences"
}
