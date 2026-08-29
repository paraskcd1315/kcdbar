import CoreGraphics

package enum TaskbarPreviewMetrics {
    package static let thumbnailWidth: CGFloat = 168
    package static let thumbnailHeight: CGFloat = 104
    package static let thumbnailSpacing: CGFloat = 6
    package static let thumbnailCornerRadius: CGFloat = 6
    package static let maximumThumbnails = 4
    package static let captureScale: CGFloat = 2
    package static let fallbackIconSide: CGFloat = 48

    package static var thumbnailSize: CGSize {
        CGSize(width: thumbnailWidth, height: thumbnailHeight)
    }

    package static func captureSize(for tile: CGSize) -> CGSize {
        CGSize(width: tile.width * captureScale, height: tile.height * captureScale)
    }

    package static var panelAllowance: CGFloat {
        TaskbarMetrics.tooltipAllowance + thumbnailHeight + thumbnailSpacing
    }
}
