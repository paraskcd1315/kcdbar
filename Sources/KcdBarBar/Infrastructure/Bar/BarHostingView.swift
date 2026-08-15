import AppKit
import SwiftUI

package final class BarHostingView<Content: View>: NSHostingView<Content> {
    package override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }
}
