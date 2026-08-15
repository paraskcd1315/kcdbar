import Foundation

/** Whether an application already has a window on the display the user clicked. */
package enum NewWindowPlacement {
    package static func hasWindow(
        pid: pid_t,
        onDisplay displayId: Int,
        among entries: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> Bool {
        entries.contains { window in
            window.ownerPid == pid
                && WindowDisplayResolver.displayId(for: window, in: displays) == displayId
        }
    }
}
