import AppKit

package final class MiddleClickCatchingView: NSView {
    package var action: (() -> Void)?

    package override func otherMouseUp(with event: NSEvent) {
        guard event.buttonNumber == MiddleClickMetrics.buttonNumber,
              bounds.contains(convert(event.locationInWindow, from: nil))
        else {
            super.otherMouseUp(with: event)
            return
        }
        action?()
    }

    package override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }

    package override var acceptsFirstResponder: Bool {
        false
    }
}
