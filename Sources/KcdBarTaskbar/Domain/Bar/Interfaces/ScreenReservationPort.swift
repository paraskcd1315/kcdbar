import CoreGraphics

/** Reserves a strip of a display so other applications' windows stop at its edge. */
@MainActor
package protocol ScreenReservationPort: Sendable {
    var isAvailable: Bool { get }
    func reserve(_ frame: CGRect) -> Bool
    func release()
}
