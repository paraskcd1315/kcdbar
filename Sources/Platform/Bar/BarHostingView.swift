import AppKit
import SwiftUI

final class BarHostingView<Content: View>: NSHostingView<Content> {
    private var hitRegion: BarHitRegion?

    convenience init(rootView: Content, hitRegion: BarHitRegion) {
        self.init(rootView: rootView)
        self.hitRegion = hitRegion
    }

    required init(rootView: Content) {
        super.init(rootView: rootView)
    }

    @MainActor required dynamic init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        guard let rect = hitRegion?.rect else { return super.hitTest(point) }

        return rect.contains(convert(point, from: superview)) ? super.hitTest(point) : nil
    }
}
