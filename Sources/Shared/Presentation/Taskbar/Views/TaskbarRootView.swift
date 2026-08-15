import SwiftUI

struct TaskbarRootView: View {
    let registry: WindowRegistry
    let preset: BarPreset
    let displayId: Int
    let icons: any ApplicationIconPort
    let onActivate: (TaskbarEntryModel) -> Void
    let onRequestAccessibility: () -> Void

    var body: some View {
        TaskbarView(
            viewModel: viewModel,
            onActivate: onActivate,
            onRequestAccessibility: onRequestAccessibility
        )
    }

    private var viewModel: TaskbarViewModel {
        TaskbarViewModel(
            preset: preset,
            windows: registry.taskbarEntries,
            displayId: displayId,
            displays: registry.displays,
            frontmostPid: registry.frontmostPid,
            hasAccessibility: registry.hasAccessibility,
            icons: icons
        )
    }
}
