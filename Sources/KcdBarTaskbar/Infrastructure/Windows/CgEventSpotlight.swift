import AppKit

/** Opens Spotlight and switches it to Applications, since no API exposes either. */
@MainActor
package struct CgEventSpotlight: SpotlightPort {
    package init() {}

    package func openApplications() -> Bool {
        guard press(SpotlightMetrics.spaceKey) else { return false }

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(SpotlightMetrics.applicationsDelay))
            _ = press(SpotlightMetrics.oneKey)
        }

        return true
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
