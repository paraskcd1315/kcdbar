import SwiftUI

/** A rounded panel with a caret on its lower edge, pointing at the item that opened it. */
struct BatteryPopoverShape: Shape {
    let arrowX: CGFloat

    func path(in rect: CGRect) -> Path {
        let arrow = BatteryMetrics.arrowSize
        let radius = KbRadii.lg
        let body = CGRect(
            x: rect.minX,
            y: rect.minY,
            width: rect.width,
            height: rect.height - arrow.height
        )
        let tip = min(max(arrowX, body.minX + radius + arrow.width), body.maxX - radius - arrow.width)

        var path = Path(roundedRect: body, cornerRadius: radius)
        path.move(to: CGPoint(x: tip - arrow.width / 2, y: body.maxY))
        path.addLine(to: CGPoint(x: tip, y: rect.maxY))
        path.addLine(to: CGPoint(x: tip + arrow.width / 2, y: body.maxY))
        path.closeSubpath()

        return path
    }
}
