import SwiftUI

/** The Bluetooth rune, which SF Symbols does not ship. */
struct KbBluetoothShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: point(rect, 0.16, 0.30))
        path.addLine(to: point(rect, 0.84, 0.70))
        path.addLine(to: point(rect, 0.50, 0.98))
        path.addLine(to: point(rect, 0.50, 0.02))
        path.addLine(to: point(rect, 0.84, 0.30))
        path.addLine(to: point(rect, 0.16, 0.70))

        return path
    }

    private func point(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: rect.minX + rect.width * x, y: rect.minY + rect.height * y)
    }
}
