import Foundation

/** What the solo policy displaced, so a display can hand its last window back. */
package struct SoloWindowMemory: Equatable {
    package private(set) var displaced: [Int: [WindowIdentity]] = [:]

    package init() {}

    package mutating func remember(_ windows: [ManagedWindow], onDisplay display: Int) {
        var stack = displaced[display] ?? []
        for window in windows where !stack.contains(window.identity) {
            stack.append(window.identity)
        }
        displaced[display] = stack
    }

    package mutating func forget(_ identity: WindowIdentity, onDisplay display: Int) {
        displaced[display]?.removeAll { $0 == identity }
    }

    package mutating func takeMostRecent(onDisplay display: Int) -> WindowIdentity? {
        guard var stack = displaced[display], let last = stack.popLast() else { return nil }

        displaced[display] = stack

        return last
    }

    package mutating func drop(identitiesNotIn alive: Set<WindowIdentity>) {
        for display in displaced.keys {
            displaced[display] = displaced[display]?.filter { alive.contains($0) }
        }
    }
}
