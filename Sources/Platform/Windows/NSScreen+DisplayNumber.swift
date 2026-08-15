import AppKit

extension NSScreen {
    /** The CoreGraphics display id. */
    var displayNumber: Int? {
        (deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.intValue
    }
}
