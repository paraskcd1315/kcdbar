import CoreGraphics

/** The size a thumbnail draws at: the window's own shape, no larger than the ceiling. */
package enum TaskbarPreviewFit {
    package static func size(of window: CGSize, within ceiling: CGSize) -> CGSize {
        guard window.width > 0, window.height > 0 else { return ceiling }

        let scale = min(ceiling.width / window.width, ceiling.height / window.height, 1)

        return CGSize(
            width: (window.width * scale).rounded(),
            height: (window.height * scale).rounded()
        )
    }
}
