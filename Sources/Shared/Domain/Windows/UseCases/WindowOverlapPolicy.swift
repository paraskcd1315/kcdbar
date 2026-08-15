import CoreGraphics

enum WindowOverlapPolicy {
    static func correctedFrame(
        for window: ManagedWindow,
        barFrame: CGRect,
        display: DisplayGeometry
    ) -> CGRect? {
        guard let bounds = window.bounds, !window.isMinimized else { return nil }
        guard fillsDisplay(bounds, display: display) else { return nil }
        guard bounds.intersects(barFrame) else { return nil }

        let available = usableArea(of: display, excluding: barFrame)
        let corrected = bounds.intersection(available)
        guard !corrected.isNull, corrected.height > 0, corrected.width > 0 else { return nil }
        guard !isSame(corrected, bounds) else { return nil }
        return corrected
    }

    static func usableArea(of display: DisplayGeometry, excluding barFrame: CGRect) -> CGRect {
        let screen = display.frame
        guard screen.intersects(barFrame) else { return screen }

        let tolerance = WindowMatchingMetrics.boundsTolerance

        if barFrame.width >= screen.width - tolerance {
            if barFrame.minY <= screen.minY + tolerance {
                return CGRect(
                    x: screen.minX,
                    y: barFrame.maxY,
                    width: screen.width,
                    height: screen.maxY - barFrame.maxY
                )
            }
            return CGRect(x: screen.minX, y: screen.minY, width: screen.width, height: barFrame.minY - screen.minY)
        }

        if barFrame.minX <= screen.minX + tolerance {
            return CGRect(
                x: barFrame.maxX,
                y: screen.minY,
                width: screen.maxX - barFrame.maxX,
                height: screen.height
            )
        }
        return CGRect(x: screen.minX, y: screen.minY, width: barFrame.minX - screen.minX, height: screen.height)
    }

    private static func fillsDisplay(_ bounds: CGRect, display: DisplayGeometry) -> Bool {
        let screen = display.frame
        let coverage = bounds.intersection(screen)
        guard !coverage.isNull else { return false }
        return coverage.width >= screen.width * displayFillRatio
            && coverage.height >= screen.height * displayFillRatio
    }

    private static func isSame(_ lhs: CGRect, _ rhs: CGRect) -> Bool {
        let tolerance = WindowMatchingMetrics.boundsTolerance
        return abs(lhs.minX - rhs.minX) <= tolerance
            && abs(lhs.minY - rhs.minY) <= tolerance
            && abs(lhs.width - rhs.width) <= tolerance
            && abs(lhs.height - rhs.height) <= tolerance
    }

    private static let displayFillRatio: CGFloat = 0.92
}
