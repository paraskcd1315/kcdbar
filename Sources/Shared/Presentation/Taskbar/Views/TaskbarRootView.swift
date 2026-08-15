import SwiftUI

struct TaskbarRootView: View {
    let registry: WindowRegistry
    let pins: PinnedAppState
    let order: EntryOrderMemory
    let desktop: ShowDesktopState
    let preset: BarPreset
    let displayId: Int
    let icons: any ApplicationIconPort
    let onActivate: (TaskbarEntryModel) -> Void
    let onRequestAccessibility: () -> Void
    let onOpenStart: () -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onDropPin: (String, TaskbarEntryModel) -> Void
    let onToggleDesktop: () -> Void
    let onMiddleClick: (TaskbarEntryModel) -> Void
    let battery: BatteryMonitor
    let onOpenBattery: () -> Void
    let onOpenNotifications: () -> Void
    let onOpenControlCentre: () -> Void

    var body: some View {
        TaskbarView(
            viewModel: viewModel,
            onActivate: onActivate,
            onRequestAccessibility: onRequestAccessibility,
            onOpenStart: onOpenStart,
            onTogglePin: onTogglePin,
            onDropPin: onDropPin,
            onMiddleClick: onMiddleClick,
            battery: battery.state,
            onOpenBattery: onOpenBattery,
            onOpenNotifications: onOpenNotifications,
            onOpenControlCentre: onOpenControlCentre,
            isShowingDesktop: desktop.isShowingDesktop,
            onToggleDesktop: onToggleDesktop
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
            ranks: order.ranks,
            hasAccessibility: registry.hasAccessibility,
            icons: icons
        )
    }
}
