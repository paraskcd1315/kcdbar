import CoreGraphics

/** Whether a hidden bar should come back for a pointer at its screen edge. */
enum BarRevealPolicy {
    static func shouldReveal(
        pointer: CGPoint,
        barFrame: CGRect,
        display: DisplayGeometry,
        edge: BarEdge
    ) -> Bool {
        guard contains(display.frame, pointer) else { return false }
        guard !contains(barFrame, pointer) else { return true }

        let screen = display.frame
        let threshold = BarRevealMetrics.edgeThreshold

        switch edge {
        case .bottom: return pointer.y <= screen.minY + threshold
        case .top: return pointer.y >= screen.maxY - threshold
        case .leading: return pointer.x <= screen.minX + threshold
        case .trailing: return pointer.x >= screen.maxX - threshold
        }
    }

    static func concealedFrame(_ frame: CGRect, edge: BarEdge) -> CGRect {
        switch edge {
        case .bottom: frame.offsetBy(dx: 0, dy: -frame.height)
        case .top: frame.offsetBy(dx: 0, dy: frame.height)
        case .leading: frame.offsetBy(dx: -frame.width, dy: 0)
        case .trailing: frame.offsetBy(dx: frame.width, dy: 0)
        }
    }

    private static func contains(_ frame: CGRect, _ point: CGPoint) -> Bool {
        point.x >= frame.minX && point.x <= frame.maxX
            && point.y >= frame.minY && point.y <= frame.maxY
    }
}
