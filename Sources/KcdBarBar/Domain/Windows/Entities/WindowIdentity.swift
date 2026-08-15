import CoreGraphics

struct WindowIdentity: Hashable, Sendable {
    let ownerPid: pid_t
    let cgWindowId: CGWindowID?
    let fallbackKey: String

    init(ownerPid: pid_t, cgWindowId: CGWindowID?, fallbackKey: String) {
        self.ownerPid = ownerPid
        self.cgWindowId = cgWindowId
        self.fallbackKey = fallbackKey
    }
}
