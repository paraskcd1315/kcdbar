import CoreGraphics

/** The primary display's top in Cocoa coordinates — what a CoreGraphics rect is flipped against. */
package enum DisplayFlipReference {
    package static func of(_ displays: [DisplayGeometry]) -> CGFloat {
        displays.first(where: \.isPrimary)?.frame.maxY ?? 0
    }
}
