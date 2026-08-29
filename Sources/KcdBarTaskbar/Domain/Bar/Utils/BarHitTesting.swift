import CoreGraphics

package enum BarHitTesting {
    package static func screenRect(ofView viewRect: CGRect, inPanel panelFrame: CGRect) -> CGRect {
        CGRect(
            x: panelFrame.minX + viewRect.minX,
            y: panelFrame.maxY - viewRect.maxY,
            width: viewRect.width,
            height: viewRect.height
        )
    }

    package static func passesThrough(
        _ point: CGPoint,
        barRect: CGRect?,
        tooltipRect: CGRect? = nil,
        panelFrame: CGRect
    ) -> Bool {
        guard let barRect else { return false }
        if screenRect(ofView: barRect, inPanel: panelFrame).contains(point) { return false }
        if let tooltipRect, screenRect(ofView: tooltipRect, inPanel: panelFrame).contains(point) {
            return false
        }

        return true
    }
}
