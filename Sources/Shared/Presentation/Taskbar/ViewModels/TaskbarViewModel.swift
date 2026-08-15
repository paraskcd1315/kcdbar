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
        bundleIdentifiers: [pid_t: String],
        pinnedApps: [PinnedApp],
        ranks: [String: Int],
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
        let pinnedIdentifiers = Set(pinnedApps.map(\.bundleIdentifier))
        let windowsPerApplication = Dictionary(
            grouping: windows.compactMap { bundleIdentifiers[$0.ownerPid] },
            by: { $0 }
        ).mapValues(\.count)

        let windowEntries = scoped.map { window -> TaskbarEntryModel in
            let bundleIdentifier = bundleIdentifiers[window.ownerPid]
            return TaskbarEntryModel(
                id: WindowEntryIdentifier.text(for: window.identity),
                title: window.title ?? window.ownerName ?? "",
                applicationName: window.ownerName ?? "",
                bundleIdentifier: bundleIdentifier,
                icon: icons.icon(forPid: window.ownerPid),
                isMinimized: window.isMinimized,
                isFrontmost: WindowFocusPolicy.isFrontmost(
                    window,
                    frontmostPid: frontmostPid,
                    among: windows
                ),
                isPinned: bundleIdentifier.map(pinnedIdentifiers.contains) ?? false,
                isLauncher: false,
                instanceCount: bundleIdentifier.flatMap { windowsPerApplication[$0] } ?? 1
            )
        }

        let representedIdentifiers = Set(windowEntries.compactMap(\.bundleIdentifier))
        let launchers = pinnedApps
            .filter { !representedIdentifiers.contains($0.bundleIdentifier) }
            .map { app in
                TaskbarEntryModel(
                    id: "pin:\(app.bundleIdentifier)",
                    title: app.displayName,
                    applicationName: app.displayName,
                    bundleIdentifier: app.bundleIdentifier,
                    icon: icons.icon(forBundleIdentifier: app.bundleIdentifier),
                    isMinimized: false,
                    isFrontmost: false,
                    isPinned: true,
                    isLauncher: true,
                    instanceCount: windowsPerApplication[app.bundleIdentifier] ?? 0
                )
            }

        entries = TaskbarOrdering.ordered(entries: launchers + windowEntries, ranks: ranks)
        notice = hasAccessibility ? nil : .accessibilityMissing
    }
}
