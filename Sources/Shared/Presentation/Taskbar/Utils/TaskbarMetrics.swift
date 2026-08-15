import CoreGraphics
import Foundation

enum TaskbarMetrics {
    static let reconciliationSweepInterval: TimeInterval = 5.0
    static let iconSize: CGFloat = 34
    static let iconOnlyEntryWidth: CGFloat = 56
    static let entryMinWidth: CGFloat = 96
    static let entryCompactWidth: CGFloat = 52
    static let entryMaxWidth: CGFloat = 220
    static let indicatorHeight: CGFloat = 2
    static let indicatorWidth: CGFloat = 16
    static let islandOutset: CGFloat = 6
    static let magnificationScale: CGFloat = 1.35
    static let hoverScale: CGFloat = 1.04
    static let hoverFillOpacity: Double = 0.10
    static let focusedFillOpacity: Double = 0.16
    static let insertionScale: CGFloat = 0.4
    static let startGlyphSize: CGFloat = 15
    static let startButtonWidth: CGFloat = 40
    static let dropIndicatorWidth: CGFloat = 3
    static let tooltipAllowance: CGFloat = 44
    static let tooltipGap: CGFloat = 8
    static let tooltipDelay: Duration = .milliseconds(400)
    static let tooltipMaxWidth: CGFloat = 320
}
