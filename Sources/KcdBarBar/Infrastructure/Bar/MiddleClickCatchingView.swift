import AppKit

final class MiddleClickCatchingView: NSView {
    var action: (() -> Void)?

    override func otherMouseUp(with event: NSEvent) {
        guard event.buttonNumber == MiddleClickMetrics.buttonNumber,
              bounds.contains(convert(event.locationInWindow, from: nil))
        else {
            super.otherMouseUp(with: event)
            return
        }
        action?()
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }

    override var acceptsFirstResponder: Bool {
        false
    }
}
