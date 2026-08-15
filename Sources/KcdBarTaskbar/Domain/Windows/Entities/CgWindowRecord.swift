import CoreGraphics

package struct CgWindowRecord: Equatable, Sendable {
    package let windowId: CGWindowID
    package let ownerPid: pid_t
    package let ownerName: String?
    package let title: String?
    package let bounds: CGRect
    package let layer: Int
    package let isOnScreen: Bool
    package let zOrder: Int
}
