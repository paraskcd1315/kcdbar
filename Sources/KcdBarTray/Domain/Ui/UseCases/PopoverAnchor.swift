import CoreGraphics

/** Where a popover sits: centred on its anchor, above it, and never off the screen. */
package enum PopoverAnchor {
    package static func origin(for size: CGSize, anchor: CGPoint, within bounds: CGRect) -> CGPoint {
        let centred = anchor.x - size.width / PopoverPlacementMetrics.centringDivisor
        let x = min(max(centred, bounds.minX), bounds.maxX - size.width)
        let y = min(anchor.y + PopoverPlacementMetrics.gap, bounds.maxY - size.height)

        return CGPoint(x: x, y: max(y, bounds.minY))
    }

    /** The size a popover may take in the room above its anchor. */
    package static func fittedSize(_ wanted: CGSize, anchor: CGPoint, within bounds: CGRect)
        -> CGSize
    {
        let room = bounds.maxY - (anchor.y + PopoverPlacementMetrics.gap)

        return CGSize(width: wanted.width, height: min(wanted.height, max(room, 0)))
    }
}
