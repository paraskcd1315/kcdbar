import CoreGraphics

/** Whether a freshly measured popover is close enough to the last one to leave the window alone. */
package enum PopoverSizing {
    package static func isSettled(_ wanted: CGSize, against reported: CGSize) -> Bool {
        abs(wanted.width - reported.width) < PopoverPlacementMetrics.sizeTolerance
            && abs(wanted.height - reported.height) < PopoverPlacementMetrics.sizeTolerance
    }
}
