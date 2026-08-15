/** A stable string form of a window identity. */
package enum WindowEntryIdentifier {
    package static func text(for identity: WindowIdentity) -> String {
        guard let windowId = identity.cgWindowId else {
            return "ax:\(identity.fallbackKey)"
        }
        return "cg:\(windowId)"
    }
}
