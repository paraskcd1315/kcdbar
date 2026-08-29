import CoreGraphics

/** A display's frame in Cocoa coordinates. */
package struct DisplayGeometry: Equatable, Sendable, Identifiable {
    package let id: Int
    package let frame: CGRect
    package let isPrimary: Bool
    package var name: String? = nil
}
