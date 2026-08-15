import SwiftUI

/** A rounded panel, optionally carrying a caret on its lower edge that points at the item that opened it. */
package struct KbPopoverShape: Shape {
    package let arrowX: CGFloat?

    package init(arrowX: CGFloat?) {
        self.arrowX = arrowX
    }

    package func path(in rect: CGRect) -> Path {
        let radius = KbRadii.lg
        guard let arrowX else {
            return Path(roundedRect: rect, cornerRadius: radius)
        }
        let arrow = KbPopoverMetrics.arrowSize
        let body = CGRect(
            x: rect.minX,
            y: rect.minY,
            width: rect.width,
            height: rect.height - arrow.height
        )
        let lower = body.minX + radius + arrow.width
        let upper = body.maxX - radius - arrow.width
        let tip = min(max(arrowX, lower), upper)

        var path = Path(roundedRect: body, cornerRadius: radius)
        path.move(to: CGPoint(x: tip - arrow.width / 2, y: body.maxY))
        path.addLine(to: CGPoint(x: tip, y: rect.maxY))
        path.addLine(to: CGPoint(x: tip + arrow.width / 2, y: body.maxY))
        path.closeSubpath()

        return path
    }
}
