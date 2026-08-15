import CoreGraphics

struct ManagedWindow: Equatable, Sendable {
    let identity: WindowIdentity
    let ownerPid: pid_t
    let ownerName: String?
    let title: String?
    let bounds: CGRect?
    let isMinimized: Bool
    let isFullScreen: Bool
    let isOnScreen: Bool
    let zOrder: Int?
    let source: WindowRecordSource
}
