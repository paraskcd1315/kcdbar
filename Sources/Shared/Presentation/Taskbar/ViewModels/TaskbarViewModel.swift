import SwiftUI

@MainActor
struct TaskbarViewModel {
    let preset: BarPreset
    let entries: [TaskbarEntryModel]
    let notice: TaskbarNotice?

    init(
        preset: BarPreset,
        windows: [ManagedWindow],
        displayId: Int,
        displays: [DisplayGeometry],
        frontmostPid: pid_t?,
        hasAccessibility: Bool,
        icons: any ApplicationIconPort
    ) {
        self.preset = preset
        let scoped = WindowDisplayResolver.windows(
            windows,
            onDisplay: displayId,
            scope: preset.windowScope,
            displays: displays
        )
        entries = scoped.map { window in
            TaskbarEntryModel(
                id: WindowEntryIdentifier.text(for: window.identity),
                title: window.title ?? window.ownerName ?? "",
                applicationName: window.ownerName ?? "",
                icon: icons.icon(forPid: window.ownerPid),
                isMinimized: window.isMinimized,
                isFrontmost: WindowFocusPolicy.isFrontmost(
                    window,
                    frontmostPid: frontmostPid,
                    among: windows
                )
            )
        }
        notice = if !hasAccessibility {
            .accessibilityMissing
        } else if entries.isEmpty {
            .noWindows
        } else {
            nil
        }
    }
}
