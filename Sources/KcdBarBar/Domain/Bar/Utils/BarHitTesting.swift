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

    package static func passesThrough(_ point: CGPoint, barRect: CGRect?, panelFrame: CGRect) -> Bool {
        guard let barRect else { return false }

        return !screenRect(ofView: barRect, inPanel: panelFrame).contains(point)
    }
}
