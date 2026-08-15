import Foundation

enum WindowFocusPolicy {
    static func isFrontmost(
        _ window: ManagedWindow,
        frontmostPid: pid_t?,
        among windows: [ManagedWindow]
    ) -> Bool {
        guard window.ownerPid == frontmostPid, !window.isMinimized, let order = window.zOrder else {
            return false
        }
        return siblings(of: window, in: windows).allSatisfy { $0 >= order }
    }

    private static func siblings(of window: ManagedWindow, in windows: [ManagedWindow]) -> [Int] {
        windows
            .filter { $0.ownerPid == window.ownerPid && !$0.isMinimized }
            .compactMap(\.zOrder)
    }
}
