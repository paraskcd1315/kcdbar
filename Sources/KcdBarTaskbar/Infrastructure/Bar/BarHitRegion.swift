import CoreGraphics

/** Where the bar is actually drawn, so the panel's empty margins pass clicks through. */
@MainActor
package final class BarHitRegion {
    package var rect: CGRect?
}
