import CoreGraphics

/** Where a popover sits: centred on its anchor, above it, and never off the screen. */
package enum PopoverAnchor {
    package static func origin(for size: CGSize, anchor: CGPoint, within bounds: CGRect) -> CGPoint {
        let centred = anchor.x - size.width / PopoverPlacementMetrics.centringDivisor
        let x = min(max(centred, bounds.minX), bounds.maxX - size.width)
        let y = min(anchor.y + PopoverPlacementMetrics.gap, bounds.maxY - size.height)

        return CGPoint(x: x, y: max(y, bounds.minY))
    }
}
