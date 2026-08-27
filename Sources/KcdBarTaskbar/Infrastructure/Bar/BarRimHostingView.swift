import AppKit
import SwiftUI

/** Hosts the rim above the bar and takes no click, so the bar beneath keeps every one. */
package final class BarRimHostingView<Content: View>: NSHostingView<Content> {
    package override func hitTest(_ point: NSPoint) -> NSView? {
        nil
    }
}
