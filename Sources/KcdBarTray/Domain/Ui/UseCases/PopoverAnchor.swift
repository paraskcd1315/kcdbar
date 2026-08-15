import CoreGraphics

/** Where a popover sits: centred on its anchor, above it, and never off the screen. */
enum PopoverAnchor {
    static func origin(for size: CGSize, anchor: CGPoint, within bounds: CGRect) -> CGPoint {
        let centred = anchor.x - size.width / KbPopoverMetrics.centringDivisor
        let x = min(max(centred, bounds.minX), bounds.maxX - size.width)
        let y = min(anchor.y + KbPopoverMetrics.gap, bounds.maxY - size.height)

        return CGPoint(x: x, y: max(y, bounds.minY))
    }
}
