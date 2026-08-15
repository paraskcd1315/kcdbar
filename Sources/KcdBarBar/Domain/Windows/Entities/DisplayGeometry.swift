import CoreGraphics

/** A display's frame in Cocoa coordinates. */
struct DisplayGeometry: Equatable, Sendable, Identifiable {
    let id: Int
    let frame: CGRect
    let isPrimary: Bool
}
