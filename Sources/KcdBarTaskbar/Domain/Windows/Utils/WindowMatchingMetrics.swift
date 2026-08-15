import CoreGraphics

package enum WindowMatchingMetrics {
    package static let boundsTolerance: CGFloat = 4
    package static let normalWindowLayer = 0
    package static let minimumManageableSize = CGSize(width: 40, height: 40)
    package static let fullScreenAttribute = "AXFullScreen"
    package static let windowRole = "AXWindow"
    package static let switchableSubroles: Set<String> = ["AXStandardWindow", "AXDialog"]
    package static let accessibilityTimeout: Float = 0.2
}
