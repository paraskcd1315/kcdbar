import AppKit
import CoreGraphics

@MainActor
enum ScreenCoordinateConverter {
    static var flipReference: CGFloat {
        NSScreen.screens.first?.frame.maxY ?? 0
    }

    static func toCocoa(_ rect: CGRect) -> CGRect {
        flip(rect)
    }

    static func toAccessibility(_ rect: CGRect) -> CGRect {
        flip(rect)
    }

    private static func flip(_ rect: CGRect) -> CGRect {
        CGRect(
            x: rect.origin.x,
            y: flipReference - rect.origin.y - rect.height,
            width: rect.width,
            height: rect.height
        )
    }
}
