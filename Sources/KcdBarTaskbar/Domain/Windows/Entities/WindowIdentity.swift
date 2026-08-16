import CoreGraphics

package struct WindowIdentity: Hashable, Sendable {
    package let ownerPid: pid_t
    package let cgWindowId: CGWindowID?
    package let fallbackKey: String

    package init(ownerPid: pid_t, cgWindowId: CGWindowID?, fallbackKey: String) {
        self.ownerPid = ownerPid
        self.cgWindowId = cgWindowId
        self.fallbackKey = fallbackKey
    }
}
