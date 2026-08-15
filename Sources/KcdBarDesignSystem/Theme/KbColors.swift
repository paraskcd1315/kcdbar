import SwiftUI

package enum KbColors {
    package static let surface = Color(red: 0.11, green: 0.11, blue: 0.12)
    package static let surfaceRaised = Color(red: 0.16, green: 0.16, blue: 0.18)
    package static let onSurface = Color.white
    package static let onSurfaceMuted = Color.white.opacity(0.62)
    package static let brand = Color.accentColor
    package static let onBrand = Color.white
    package static let separator = Color.white.opacity(0.12)
    package static let activeIndicator = Color.accentColor
    package static let sliderTrack = Color.black.opacity(0.28)
    package static let sliderFill = Color.white.opacity(0.88)
    package static let glassEdgeBright = Color.white.opacity(0.65)
    package static let glassEdgeShade = Color.black.opacity(0.5)
    package static let batteryFull = Color(red: 0.30, green: 0.78, blue: 0.36)
    package static let batteryWarning = Color(red: 0.98, green: 0.71, blue: 0.20)
    package static let batteryCritical = Color(red: 0.94, green: 0.31, blue: 0.27)
    package static let batteryPowerSave = Color(red: 0.98, green: 0.82, blue: 0.16)
}
