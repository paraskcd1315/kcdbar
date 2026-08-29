import CoreGraphics

/** Whether a hidden bar should come back for a pointer at its screen edge, or stay for one on the bar or its preview. */
package enum BarRevealPolicy {
    package static func shouldReveal(
        pointer: CGPoint,
        barFrame: CGRect,
        previewFrame: CGRect? = nil,
        display: DisplayGeometry,
        edge: BarEdge,
        revealed: Bool
    ) -> Bool {
        guard contains(display.frame, pointer) else { return false }
        if revealed, contains(barFrame, pointer) { return true }
        if revealed, let previewFrame,
           contains(reach(previewFrame, toward: barFrame, edge: edge), pointer) {
            return true
        }

        let screen = display.frame
        let threshold = BarRevealMetrics.edgeThreshold

        switch edge {
        case .bottom: return pointer.y <= screen.minY + threshold
        case .top: return pointer.y >= screen.maxY - threshold
        case .leading: return pointer.x <= screen.minX + threshold
        case .trailing: return pointer.x >= screen.maxX - threshold
        }
    }

    package static func concealedFrame(_ frame: CGRect, edge: BarEdge) -> CGRect {
        switch edge {
        case .bottom: frame.offsetBy(dx: 0, dy: -frame.height)
        case .top: frame.offsetBy(dx: 0, dy: frame.height)
        case .leading: frame.offsetBy(dx: -frame.width, dy: 0)
        case .trailing: frame.offsetBy(dx: frame.width, dy: 0)
        }
    }

    package static func reach(_ previewFrame: CGRect, toward barFrame: CGRect, edge: BarEdge) -> CGRect {
        switch edge {
        case .bottom:
            CGRect(x: previewFrame.minX, y: min(barFrame.maxY, previewFrame.minY),
                   width: previewFrame.width, height: previewFrame.maxY - min(barFrame.maxY, previewFrame.minY))
        case .top:
            CGRect(x: previewFrame.minX, y: previewFrame.minY,
                   width: previewFrame.width, height: max(barFrame.minY, previewFrame.maxY) - previewFrame.minY)
        case .leading:
            CGRect(x: min(barFrame.maxX, previewFrame.minX), y: previewFrame.minY,
                   width: previewFrame.maxX - min(barFrame.maxX, previewFrame.minX), height: previewFrame.height)
        case .trailing:
            CGRect(x: previewFrame.minX, y: previewFrame.minY,
                   width: max(barFrame.minX, previewFrame.maxX) - previewFrame.minX, height: previewFrame.height)
        }
    }

    private static func contains(_ frame: CGRect, _ point: CGPoint) -> Bool {
        point.x >= frame.minX && point.x <= frame.maxX
            && point.y >= frame.minY && point.y <= frame.maxY
    }
}
