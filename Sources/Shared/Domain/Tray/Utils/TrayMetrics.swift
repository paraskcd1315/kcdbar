import Foundation

enum TrayMetrics {
    static let systemBundlePrefix = "com.apple."
    static let extrasMenuBarAttribute = "AXExtrasMenuBar"
    static let iconSize: CGFloat = 18
    static let cancelAction = "AXCancel"
    static let pressTimeout: Float = 0.25
    static let menuBuildAllowance: TimeInterval = 0.6
    static let menuWidth: CGFloat = 260
    static let menuMaxHeight: CGFloat = 420
    static let menuGap: CGFloat = 8
    static let separatorHeight: CGFloat = 1
    static let glyphLuminanceMidpoint: Double = 0.5
    static let glyphScale: CGFloat = 2
}
