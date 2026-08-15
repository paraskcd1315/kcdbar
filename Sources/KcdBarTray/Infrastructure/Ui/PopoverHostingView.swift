import AppKit
import SwiftUI

/** Hosts a popover's content and reports the size that content asks for. */
package final class PopoverHostingView<Content: View>: NSHostingView<Content> {
    package var onContentSizeChange: ((CGSize) -> Void)?

    private var reported: CGSize = .zero

    package required init(rootView: Content) {
        super.init(rootView: rootView)
        sizingOptions = [.intrinsicContentSize]
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        fatalError("init(coder:) is not available")
    }

    package override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()

        Task { [weak self] in self?.report() }
    }

    package override func layout() {
        super.layout()
        report()
    }

    package override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }

    private func report() {
        let wanted = intrinsicContentSize
        guard wanted.width > 0, wanted.height > 0 else { return }
        guard !PopoverSizing.isSettled(wanted, against: reported) else { return }

        reported = wanted
        onContentSizeChange?(wanted)
    }
}
