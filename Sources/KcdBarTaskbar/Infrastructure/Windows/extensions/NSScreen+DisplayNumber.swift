import AppKit

package extension NSScreen {
    /** The CoreGraphics display id. */
    var displayNumber: Int? {
        (deviceDescription[NSDeviceDescriptionKey(SystemDefaultsKeys.screenNumber)] as? NSNumber)?
            .intValue
    }
}
