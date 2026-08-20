import SwiftUI

package struct KbWindows11Shape: Shape {
    package init() {}

    package func path(in rect: CGRect) -> Path {
        let side = min(rect.width, rect.height)
        let pane = side * KbWindowsMarkMetrics.paneRatio
        let gap = side * KbWindowsMarkMetrics.gapRatio
        let radius = side * KbWindowsMarkMetrics.paneRadiusRatio
        let origin = CGPoint(
            x: rect.midX - (pane + gap / 2),
            y: rect.midY - (pane + gap / 2)
        )

        var path = Path()
        for column in 0..<2 {
            for row in 0..<2 {
                let frame = CGRect(
                    x: origin.x + CGFloat(column) * (pane + gap),
                    y: origin.y + CGFloat(row) * (pane + gap),
                    width: pane,
                    height: pane
                )
                path.addRoundedRect(in: frame, cornerSize: CGSize(width: radius, height: radius))
            }
        }
        return path
    }
}
