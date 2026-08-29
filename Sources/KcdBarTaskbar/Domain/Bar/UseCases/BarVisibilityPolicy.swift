import CoreGraphics

/** Whether the bar yields its display. */
package enum BarVisibilityPolicy {
    package static func isHidden(
        preset: BarPreset,
        onDisplay displayId: Int,
        windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> Bool {
        reason(preset: preset, onDisplay: displayId, windows: windows, displays: displays) != nil
    }

    package static func reason(
        preset: BarPreset,
        onDisplay displayId: Int,
        windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> BarVisibilityReason? {
        let confirmed = WindowPresentationPolicy.taskbarEntries(from: windows)

        if frontmost(onDisplay: displayId, windows: confirmed, displays: displays)?.isFullScreen == true {
            return .fullScreenWindow
        }
        switch preset.autoHide {
        case .never:
            return nil
        case .always:
            return .alwaysHidden
        case .whenOverlapped:
            let overlapped = isOverlapped(
                preset: preset,
                onDisplay: displayId,
                windows: confirmed,
                displays: displays
            )

            return overlapped ? .overlappingWindow : nil
        }
    }

    private static func isOverlapped(
        preset: BarPreset,
        onDisplay displayId: Int,
        windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> Bool {
        guard let display = displays.first(where: { $0.id == displayId }) else { return false }

        let bar = BarFrameCalculator.frame(for: preset, on: display)

        return windows.contains { window in
            guard !window.isMinimized, let bounds = window.bounds else { return false }
            guard WindowSpacePolicy.isOnActiveSpace(window) else { return false }
            guard WindowDisplayResolver.displayId(for: window, in: displays) == displayId else { return false }

            return bounds.intersects(bar)
        }
    }

    private static func frontmost(
        onDisplay displayId: Int,
        windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> ManagedWindow? {
        windows
            .filter { window in
                guard !window.isMinimized, WindowSpacePolicy.isOnActiveSpace(window) else {
                    return false
                }

                return WindowDisplayResolver.displayId(for: window, in: displays) == displayId
            }
            .min { ($0.zOrder ?? Int.max) < ($1.zOrder ?? Int.max) }
    }
}
