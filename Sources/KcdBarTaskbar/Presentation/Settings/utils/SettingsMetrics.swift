import CoreGraphics

package enum SettingsMetrics {
    package static let windowWidth: CGFloat = 760
    package static let windowHeight: CGFloat = 560
    package static let sidebarMinWidth: CGFloat = 180
    package static let sidebarWidth: CGFloat = 220
    package static let sidebarMaxWidth: CGFloat = 280
    package static let symbolWidth: CGFloat = 24
    package static let sheetWidth: CGFloat = 360
    package static let thickness: ClosedRange<CGFloat> = 28...96
    package static let cornerRadius: ClosedRange<CGFloat> = 0...32
    package static let entryCornerRadius: ClosedRange<CGFloat> = 0...32
    package static let iconSize: ClosedRange<CGFloat> = 16...64
    package static let spacing: ClosedRange<CGFloat> = 0...24
    package static let padding: ClosedRange<CGFloat> = 0...24
}
