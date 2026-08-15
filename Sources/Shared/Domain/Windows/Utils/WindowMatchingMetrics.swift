import CoreGraphics

enum WindowMatchingMetrics {
    static let boundsTolerance: CGFloat = 4
    static let normalWindowLayer = 0
    static let minimumManageableSize = CGSize(width: 40, height: 40)
    static let fullScreenAttribute = "AXFullScreen"
    static let windowRole = "AXWindow"
    static let switchableSubroles: Set<String> = ["AXStandardWindow", "AXDialog"]
    static let accessibilityTimeout: Float = 0.2
}
