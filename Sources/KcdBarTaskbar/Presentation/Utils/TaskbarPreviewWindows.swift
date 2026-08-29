import CoreGraphics
import Foundation

/** The windows an entry previews, each naming the display it sits on when that is not this one. */
package enum TaskbarPreviewWindows {
    package static func of(
        _ window: ManagedWindow,
        onDisplay displayId: Int,
        displays: [DisplayGeometry]
    ) -> TaskbarPreviewWindow? {
        guard let id = window.identity.cgWindowId else { return nil }

        return TaskbarPreviewWindow(
            id: id,
            size: window.bounds?.size ?? .zero,
            displayName: displayName(of: window, awayFrom: displayId, displays: displays),
            isFullScreen: window.isFullScreen,
            title: window.title,
            profile: ChromeWindowTitle.profile(of: window.accessibilityTitle)
        )
    }

    package static func of(
        bundleIdentifier: String,
        among windows: [ManagedWindow],
        bundleIdentifiers: [pid_t: String],
        onDisplay displayId: Int,
        displays: [DisplayGeometry]
    ) -> [TaskbarPreviewWindow] {
        windows
            .filter { bundleIdentifiers[$0.ownerPid] == bundleIdentifier }
            .compactMap { of($0, onDisplay: displayId, displays: displays) }
    }

    package static func unique(_ windows: [TaskbarPreviewWindow]) -> [TaskbarPreviewWindow] {
        var seen: Set<CGWindowID> = []

        return windows.filter { seen.insert($0.id).inserted }
    }

    private static func displayName(
        of window: ManagedWindow,
        awayFrom displayId: Int,
        displays: [DisplayGeometry]
    ) -> String? {
        guard let home = WindowDisplayResolver.displayId(for: window, in: displays), home != displayId else {
            return nil
        }

        return displays.first { $0.id == home }?.name
    }
}
