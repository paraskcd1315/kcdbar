import Foundation
import SwiftData
import KcdBarTaskbar

/** The one row holding what the app remembers between launches. */
@Model
package final class StoredPreferences {
    @Attribute(.unique) package var id: String
    package var activePresetName: String
    package var hasCompletedOnboarding: Bool

    package init(activePresetName: String, hasCompletedOnboarding: Bool) {
        self.id = StoredPreferences.singletonKey
        self.activePresetName = activePresetName
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }

    package static let singletonKey = "preferences"
}
