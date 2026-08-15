import SwiftUI

struct TaskbarRootView: View {
    let registry: WindowRegistry
    let pins: PinnedAppState
    let preset: BarPreset
    let displayId: Int
    let icons: any ApplicationIconPort
    let onActivate: (TaskbarEntryModel) -> Void
    let onRequestAccessibility: () -> Void
    let onOpenStart: () -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onDropPin: (String, TaskbarEntryModel) -> Void

    var body: some View {
        TaskbarView(
            viewModel: viewModel,
            onActivate: onActivate,
            onRequestAccessibility: onRequestAccessibility,
            onOpenStart: onOpenStart,
            onTogglePin: onTogglePin,
            onDropPin: onDropPin
        )
    }

    private var viewModel: TaskbarViewModel {
        TaskbarViewModel(
            preset: preset,
            windows: registry.taskbarEntries,
            displayId: displayId,
            displays: registry.displays,
            frontmostPid: registry.frontmostPid,
            bundleIdentifiers: registry.bundleIdentifiers,
            pinnedApps: pins.apps,
            hasAccessibility: registry.hasAccessibility,
            icons: icons
        )
    }
}
