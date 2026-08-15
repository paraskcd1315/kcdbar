import SwiftUI

struct TaskbarRootView: View {
    let registry: WindowRegistry
    let tray: MenuBarItemRegistry
    let pins: PinnedAppState
    let order: EntryOrderMemory
    let desktop: ShowDesktopState
    let preset: BarPreset
    let displayId: Int
    let icons: any ApplicationIconPort
    let trayIcons: any MenuBarIconPort
    let onActivate: (TaskbarEntryModel) -> Void
    let onRequestAccessibility: () -> Void
    let onOpenStart: () -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onDropPin: (String, TaskbarEntryModel) -> Void
    let onToggleDesktop: () -> Void
    let onMiddleClick: (TaskbarEntryModel) -> Void
    let onPressTrayItem: (TrayItemModel) -> Void

    var body: some View {
        TaskbarView(
            viewModel: viewModel,
            onActivate: onActivate,
            onRequestAccessibility: onRequestAccessibility,
            onOpenStart: onOpenStart,
            onTogglePin: onTogglePin,
            onDropPin: onDropPin,
            onMiddleClick: onMiddleClick,
            onPressTrayItem: onPressTrayItem,
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
            menuBarItems: tray.items,
            ranks: order.ranks,
            hasAccessibility: registry.hasAccessibility,
            icons: icons,
            trayIcons: trayIcons
        )
    }
}
