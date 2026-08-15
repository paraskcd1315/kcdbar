import SwiftUI

/** Traces the bar's free edges, leaving out the one attached to the screen. */
struct KbBarEdgeOutline: Shape {
    let edge: BarEdge
    let attachment: BarAttachment
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        guard attachment == .edgeAttached else {
            return Path(roundedRect: rect, cornerRadius: cornerRadius)
        }

        let corners = traversal(in: rect)
        var path = Path()
        path.move(to: corners[0])
        path.addArc(tangent1End: corners[1], tangent2End: corners[2], radius: cornerRadius)
        path.addArc(tangent1End: corners[2], tangent2End: corners[3], radius: cornerRadius)
        path.addLine(to: corners[3])

        return path
    }

    private func traversal(in rect: CGRect) -> [CGPoint] {
        let topLeading = CGPoint(x: rect.minX, y: rect.minY)
        let topTrailing = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeading = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomTrailing = CGPoint(x: rect.maxX, y: rect.maxY)

        switch edge {
        case .bottom: return [bottomLeading, topLeading, topTrailing, bottomTrailing]
        case .top: return [topLeading, bottomLeading, bottomTrailing, topTrailing]
        case .leading: return [topLeading, topTrailing, bottomTrailing, bottomLeading]
        case .trailing: return [topTrailing, topLeading, bottomLeading, bottomTrailing]
        }
    }
}
