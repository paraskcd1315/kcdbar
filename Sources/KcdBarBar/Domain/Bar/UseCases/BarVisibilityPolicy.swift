import CoreGraphics

/** Whether the bar yields the display to a full-screen window. */
enum BarVisibilityPolicy {
    static func isHidden(
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
