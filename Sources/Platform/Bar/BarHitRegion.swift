import CoreGraphics

/** Where the bar is actually drawn, so the panel's empty margins pass clicks through. */
@MainActor
final class BarHitRegion {
    var rect: CGRect?
}
