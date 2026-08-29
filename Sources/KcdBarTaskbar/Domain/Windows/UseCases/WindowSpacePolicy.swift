/** Whether a window sits on the Space the user is looking at. */
package enum WindowSpacePolicy {
    package static func isOnActiveSpace(_ window: ManagedWindow) -> Bool {
        guard window.source != .inactiveSpace, let order = window.zOrder else { return false }

        return order != Int.max
    }
}
