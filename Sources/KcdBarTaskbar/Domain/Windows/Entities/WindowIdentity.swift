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

    package static func == (lhs: WindowIdentity, rhs: WindowIdentity) -> Bool {
        guard lhs.ownerPid == rhs.ownerPid else { return false }
        if let left = lhs.cgWindowId, let right = rhs.cgWindowId { return left == right }
        guard lhs.cgWindowId == nil, rhs.cgWindowId == nil else { return false }

        return lhs.fallbackKey == rhs.fallbackKey
    }

    package func hash(into hasher: inout Hasher) {
        hasher.combine(ownerPid)
        if let cgWindowId {
            hasher.combine(cgWindowId)
        } else {
            hasher.combine(fallbackKey)
        }
    }
}
