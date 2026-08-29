import SwiftUI

@MainActor
package struct TaskbarViewModel {
    package let preset: BarPreset
    package let entries: [TaskbarEntryModel]
    package let notice: TaskbarNotice?

    package init(
        preset: BarPreset,
        windows: [ManagedWindow],
        displayId: Int,
        displays: [DisplayGeometry],
        frontmostPid: pid_t?,
        bundleIdentifiers: [pid_t: String],
        pinnedApps: [PinnedApp],
        runningApplications: [RunningApplication],
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
        let windowsHerePerApplication = Dictionary(
            grouping: scoped.compactMap { bundleIdentifiers[$0.ownerPid] },
            by: { $0 }
        ).mapValues(\.count)

        let previewsOf = { (bundleIdentifier: String) -> [TaskbarPreviewWindow] in
            TaskbarPreviewWindows.of(
                bundleIdentifier: bundleIdentifier,
                among: windows,
                bundleIdentifiers: bundleIdentifiers,
                onDisplay: displayId,
                displays: displays
            )
        }
        let windowEntries = scoped.map { window -> TaskbarEntryModel in
            let bundleIdentifier = bundleIdentifiers[window.ownerPid]
            let previews = bundleIdentifier.map(previewsOf)
                ?? TaskbarPreviewWindows.of(window, onDisplay: displayId, displays: displays).map { [$0] }
                ?? []
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
                isRunning: true,
                instanceCount: bundleIdentifier.flatMap { windowsPerApplication[$0] } ?? 1,
                instancesOnThisDisplay: bundleIdentifier.flatMap { windowsHerePerApplication[$0] } ?? 1,
                previewWindows: previews,
                isFullScreen: window.isFullScreen
            )
        }

        let runningIdentifiers = Set(bundleIdentifiers.values)
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
                    isRunning: runningIdentifiers.contains(app.bundleIdentifier),
                    instanceCount: windowsPerApplication[app.bundleIdentifier] ?? 0,
                    instancesOnThisDisplay: 0,
                    previewWindows: previewsOf(app.bundleIdentifier),
                    isFullScreen: previewsOf(app.bundleIdentifier).contains(where: \.isFullScreen)
                )
            }

        let pinnedRepresented = Set(launchers.compactMap(\.bundleIdentifier))
        let windowless = runningApplications
            .filter { application in
                guard let identifier = application.bundleIdentifier else { return false }

                return !representedIdentifiers.contains(identifier)
                    && !pinnedRepresented.contains(identifier)
            }
            .map { application in
                TaskbarEntryModel(
                    id: "app:\(application.bundleIdentifier ?? "")",
                    title: application.localizedName ?? "",
                    applicationName: application.localizedName ?? "",
                    bundleIdentifier: application.bundleIdentifier,
                    icon: icons.icon(forPid: application.pid),
                    isMinimized: false,
                    isFrontmost: false,
                    isPinned: false,
                    isLauncher: true,
                    isRunning: true,
                    instanceCount: 0,
                    instancesOnThisDisplay: 0,
                    previewWindows: application.bundleIdentifier.map(previewsOf) ?? [],
                    isFullScreen: application.bundleIdentifier.map(previewsOf)?
                        .contains(where: \.isFullScreen) ?? false
                )
            }

        entries = TaskbarEntryFolding.folded(
            TaskbarOrdering.ordered(
                entries: launchers + windowless + windowEntries,
                ranks: ranks
            ),
            grouping: preset.grouping
        )
        notice = hasAccessibility ? nil : .accessibilityMissing
    }
}
