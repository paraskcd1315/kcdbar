import CoreGraphics

/** Brings the Space a window sits on to its display, so the window can be raised there. */
@MainActor
package protocol WindowSpaceFocusPort {
    func showSpace(ofWindowId windowId: CGWindowID) -> Bool
}
