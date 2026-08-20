import SwiftUI

package struct KbWindows10Shape: Shape {
    package init() {}

    package func path(in rect: CGRect) -> Path {
        let side = min(rect.width, rect.height)
        let box = CGRect(
            x: rect.midX - side / 2,
            y: rect.midY - side / 2,
            width: side,
            height: side
        )
        let rise = side * KbWindowsMarkMetrics.flagRiseRatio
        let gap = side * KbWindowsMarkMetrics.gapRatio
        let split = side * KbWindowsMarkMetrics.paneRatio

        let leftX = box.minX
        let innerLeftX = box.minX + split
        let innerRightX = box.minX + split + gap
        let rightX = box.maxX
        let midTopY = box.minY + split
        let midBottomY = box.minY + split + gap

        func topY(at x: CGFloat) -> CGFloat {
            box.minY + rise * (1 - (x - box.minX) / side)
        }

        func bottomY(at x: CGFloat) -> CGFloat {
            box.maxY - rise * (1 - (x - box.minX) / side)
        }

        var path = Path()
        path.addLines([
            CGPoint(x: leftX, y: topY(at: leftX)),
            CGPoint(x: innerLeftX, y: topY(at: innerLeftX)),
            CGPoint(x: innerLeftX, y: midTopY),
            CGPoint(x: leftX, y: midTopY)
        ])
        path.closeSubpath()
        path.addLines([
            CGPoint(x: innerRightX, y: topY(at: innerRightX)),
            CGPoint(x: rightX, y: topY(at: rightX)),
            CGPoint(x: rightX, y: midTopY),
            CGPoint(x: innerRightX, y: midTopY)
        ])
        path.closeSubpath()
        path.addLines([
            CGPoint(x: leftX, y: midBottomY),
            CGPoint(x: innerLeftX, y: midBottomY),
            CGPoint(x: innerLeftX, y: bottomY(at: innerLeftX)),
            CGPoint(x: leftX, y: bottomY(at: leftX))
        ])
        path.closeSubpath()
        path.addLines([
            CGPoint(x: innerRightX, y: midBottomY),
            CGPoint(x: rightX, y: midBottomY),
            CGPoint(x: rightX, y: bottomY(at: rightX)),
            CGPoint(x: innerRightX, y: bottomY(at: innerRightX))
        ])
        path.closeSubpath()
        return path
    }
}
