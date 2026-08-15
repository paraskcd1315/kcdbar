import Foundation

/** One window per display: everything else sharing that display is minimized. */
package enum SoloWindowPolicy {
    package static func toMinimise(
        frontmostPid: pid_t?,
        among windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> [ManagedWindow] {
        guard let focused = focused(frontmostPid: frontmostPid, among: windows),
              let display = WindowDisplayResolver.displayId(for: focused, in: displays)
        else {
            return []
        }

        return windows.filter { window in
            guard window.identity != focused.identity else { return false }
            guard !window.isMinimized, !window.isFullScreen else { return false }

            return WindowDisplayResolver.displayId(for: window, in: displays) == display
        }
    }

    private static func focused(
        frontmostPid: pid_t?,
        among windows: [ManagedWindow]
    ) -> ManagedWindow? {
        windows.first {
            WindowFocusPolicy.isFrontmost($0, frontmostPid: frontmostPid, among: windows)
        }
    }
}
