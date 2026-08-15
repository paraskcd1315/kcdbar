import AppKit
import SwiftUI

/** Hosts a popover's content and reports the size it asks for. */
package final class PopoverHostingView<Content: View>: NSHostingView<Content> {
    package var onContentSizeChange: ((CGSize) -> Void)?

    private var reported: CGSize = .zero

    package override func layout() {
        super.layout()

        let wanted = fittingSize
        guard wanted.width > 0, wanted.height > 0 else { return }
        guard !PopoverSizing.isSettled(wanted, against: reported) else { return }

        reported = wanted
        onContentSizeChange?(wanted)
    }

    package override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }
}
