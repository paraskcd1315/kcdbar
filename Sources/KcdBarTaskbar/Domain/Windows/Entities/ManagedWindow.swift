import CoreGraphics

package struct ManagedWindow: Equatable, Sendable {
    package let identity: WindowIdentity
    package let ownerPid: pid_t
    package let ownerName: String?
    package let title: String?
    package let bounds: CGRect?
    package let isMinimized: Bool
    package let isFullScreen: Bool
    package let isOnScreen: Bool
    package let zOrder: Int?
    package let source: WindowRecordSource
    package var accessibilityTitle: String? = nil
}
