import SwiftUI

enum KbColors {
    static let surface = Color(red: 0.11, green: 0.11, blue: 0.12)
    static let surfaceRaised = Color(red: 0.16, green: 0.16, blue: 0.18)
    static let onSurface = Color.white
    static let onSurfaceMuted = Color.white.opacity(0.62)
    static let brand = Color.accentColor
    static let onBrand = Color.white
    static let separator = Color.white.opacity(0.12)
    static let activeIndicator = Color.accentColor
    static let sliderTrack = Color.black.opacity(0.28)
    static let sliderFill = Color.white.opacity(0.88)
    static let glassEdgeBright = Color.white.opacity(0.65)
    static let glassEdgeShade = Color.black.opacity(0.5)
    static let batteryFull = Color(red: 0.30, green: 0.78, blue: 0.36)
    static let batteryWarning = Color(red: 0.98, green: 0.71, blue: 0.20)
    static let batteryCritical = Color(red: 0.94, green: 0.31, blue: 0.27)
    static let batteryPowerSave = Color(red: 0.98, green: 0.82, blue: 0.16)

    static func battery(_ tone: BatteryTone) -> Color {
        switch tone {
        case .full: batteryFull
        case .warning: batteryWarning
        case .critical: batteryCritical
        case .powerSave: batteryPowerSave
        }
    }
}
