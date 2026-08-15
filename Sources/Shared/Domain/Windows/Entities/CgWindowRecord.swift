import CoreGraphics

struct CgWindowRecord: Equatable, Sendable {
    let windowId: CGWindowID
    let ownerPid: pid_t
    let ownerName: String?
    let title: String?
    let bounds: CGRect
    let layer: Int
    let isOnScreen: Bool
    let zOrder: Int
}
