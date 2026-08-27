import AppKit
import CoreGraphics

@MainActor
package enum ScreenCoordinateConverter {
    package static var flipReference: CGFloat {
        NSScreen.screens.first?.frame.maxY ?? 0
    }

    package static func toCocoa(_ rect: CGRect) -> CGRect {
        flip(rect)
    }

    package static func toAccessibility(_ rect: CGRect) -> CGRect {
        flip(rect)
    }

    private static func flip(_ rect: CGRect) -> CGRect {
        flipped(rect, against: flipReference)
    }

    nonisolated package static func flipped(_ rect: CGRect, against reference: CGFloat) -> CGRect {
        CGRect(
            x: rect.origin.x,
            y: reference - rect.origin.y - rect.height,
            width: rect.width,
            height: rect.height
        )
    }
}
