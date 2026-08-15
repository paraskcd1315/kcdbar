import KcdBarDesignSystem
import SwiftUI

/** The theme colour a battery tone is drawn in. */
package enum BatteryTint {
    package static func colour(for tone: BatteryTone) -> Color {
        switch tone {
        case .full: KbColors.batteryFull
        case .warning: KbColors.batteryWarning
        case .critical: KbColors.batteryCritical
        case .powerSave: KbColors.batteryPowerSave
        }
    }
}
