import CoreGraphics

/** Whether the display's frontmost window is full screen, which is the only case the bar yields to. */
package enum BarVisibilityPolicy {
    package static func isHidden(
        onDisplay displayId: Int,
        windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> Bool {
        frontmost(onDisplay: displayId, windows: windows, displays: displays)?.isFullScreen ?? false
    }

    private static func frontmost(
        onDisplay displayId: Int,
        windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> ManagedWindow? {
        windows
            .filter { window in
                guard !window.isMinimized, let order = window.zOrder, order != Int.max else {
                    return false
                }

                return WindowDisplayResolver.displayId(for: window, in: displays) == displayId
            }
            .min { ($0.zOrder ?? Int.max) < ($1.zOrder ?? Int.max) }
    }
}
