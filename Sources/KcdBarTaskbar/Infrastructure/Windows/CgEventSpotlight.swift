import AppKit

/** Opens Spotlight, since no API exposes it. */
@MainActor
package struct CgEventSpotlight: SpotlightPort {
    package init() {}

    package func open() -> Bool {
        press(SpotlightMetrics.spaceKey)
    }

    private func press(_ key: CGKeyCode) -> Bool {
        guard let source = CGEventSource(stateID: .combinedSessionState),
              let down = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: true),
              let up = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: false)
        else {
            return false
        }
        down.flags = .maskCommand
        up.flags = .maskCommand
        down.post(tap: .cghidEventTap)
        up.post(tap: .cghidEventTap)

        return true
    }
}
