import CoreGraphics
import Foundation

package enum TaskbarMetrics {
    package static let reconciliationSweepInterval: TimeInterval = 5.0
    package static let iconOnlyEntryWidth: CGFloat = 56
    package static let entryMinWidth: CGFloat = 96
    package static let entryCompactWidth: CGFloat = 52
    package static let entryMaxWidth: CGFloat = 220
    package static let indicatorHeight: CGFloat = 2
    package static let indicatorWidth: CGFloat = 16
    package static let islandOutset: CGFloat = 6
    package static let magnificationScale: CGFloat = 1.35
    package static let hoverFillOpacity: Double = 0.10
    package static let focusedFillOpacity: Double = 0.16
    package static let insertionScale: CGFloat = 0.4
    package static let startButtonWidth: CGFloat = 40
    package static let instanceDotSize: CGFloat = 3
    package static let instanceDotSpacing: CGFloat = 3
    package static let maximumInstanceDots = 5
    package static let separatorThickness: CGFloat = 1
    package static let separatorInset: CGFloat = 6
    package static let trayEndPadding: CGFloat = 10
    package static let showDesktopHoverOpacity: Double = 0.12
    package static let showDesktopActiveOpacity: Double = 0.20
    package static let instanceDotInset: CGFloat = 2
    package static let openBorderHeight: CGFloat = 2
    package static let focusedBorderHeight: CGFloat = 3
    package static let inactiveBorderFraction: CGFloat = 0.34
    package static let showDesktopWidth: CGFloat = 10
    package static let showDesktopDividerWidth: CGFloat = 1
    package static let draggingOpacity: Double = 0.35
    package static let dragActivationDistance: CGFloat = 8
    package static let bandSpacing: CGFloat = 2
    package static let bandPadding: CGFloat = 4
    package static let controlCentreWidth: CGFloat = 24
    package static let tooltipAllowance: CGFloat = 88
    package static let tooltipGap: CGFloat = 8
    package static let tooltipDelay: Duration = .milliseconds(400)
    package static let tooltipLinger: Duration = .milliseconds(150)
    package static let stackMaxSheets = 4
    package static let stackStep: CGFloat = 2
    package static let stackInset: CGFloat = 4
    package static let stackCornerRadius: CGFloat = 5
    package static let stackFillOpacity: Double = 0.9
    package static let previewCloseSide: CGFloat = 18
    package static let previewCloseGlyph: CGFloat = 8
    package static let previewCloseSymbol = "xmark"
    package static let fullScreenBadgeSide: CGFloat = 13
    package static let fullScreenBadgeGlyph: CGFloat = 7
    package static let fullScreenBadgeSymbol = "arrow.up.left.and.arrow.down.right"
    package static let tooltipMaxWidth: CGFloat = 320
    package static let tooltipEdgeInset: CGFloat = 8
    package static let tooltipShadowRadius: CGFloat = 8
    package static let tooltipShadowOffset: CGFloat = 2
}
