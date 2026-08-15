import CoreGraphics

/** Whether the bar yields the display to a full-screen window. */
package enum BarVisibilityPolicy {
    package static func isHidden(
        onDisplay displayId: Int,
        windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> Bool {
        windows.contains { window in
            guard window.isFullScreen, !window.isMinimized, window.isOnScreen else { return false }

            return WindowDisplayResolver.displayId(for: window, in: displays) == displayId
        }
    }
}
