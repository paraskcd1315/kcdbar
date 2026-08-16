import Foundation

package enum WindowToggleDecider {
    package static func action(
        for window: ManagedWindow,
        frontmostPid: pid_t?,
        among windows: [ManagedWindow]
    ) -> WindowToggleAction {
        if window.isMinimized {
            return .restore
        }
        if WindowFocusPolicy.isFrontmost(window, frontmostPid: frontmostPid, among: windows) {
            return .minimize
        }
        return .raise
    }
}
