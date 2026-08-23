import CoreGraphics

/** The rim the whole bar wears, sized from the thickness it is drawn at. */
package enum TaskbarStreakMetrics {
    package static let rimShare: CGFloat = 0.44
    package static let blurShare: CGFloat = 0.28
    package static let rimFloor: CGFloat = 12
    package static let blurFloor: CGFloat = 8

    package static func rimWidth(for thickness: CGFloat) -> CGFloat {
        max(rimFloor, thickness * rimShare)
    }

    package static func rimBlur(for thickness: CGFloat) -> CGFloat {
        max(blurFloor, thickness * blurShare)
    }
}
