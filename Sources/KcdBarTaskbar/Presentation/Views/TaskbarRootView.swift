import KcdBarTray
import SwiftUI

package struct TaskbarRootView: View {
    package let registry: WindowRegistry
    package let pins: PinnedAppState
    package let order: EntryOrderMemory
    package let desktop: ShowDesktopState
    package let preset: BarPreset
    package let displayId: Int
    package let icons: any ApplicationIconPort
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onRequestAccessibility: () -> Void
    package let onOpenStart: () -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onCloseWindow: (TaskbarEntryModel) -> Void
    package let onQuit: (TaskbarEntryModel) -> Void
    package let onDropPin: (String, TaskbarEntryModel) -> Void
    package let onToggleDesktop: () -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void
    package let battery: BatteryMonitor
    package let onOpenBattery: () -> Void
    package let onOpenNotifications: () -> Void
    package let onOpenControlCentre: () -> Void
    package let trash: TrashMonitor
    package let timer: TimerMonitor
    package let onBarFrameChange: (CGRect) -> Void

    package var body: some View {
        TaskbarView(
            viewModel: viewModel,
            onActivate: onActivate,
            onRequestAccessibility: onRequestAccessibility,
            onOpenStart: onOpenStart,
            onTogglePin: onTogglePin,
            onCloseWindow: onCloseWindow,
            onQuit: onQuit,
            onDropPin: onDropPin,
            onMiddleClick: onMiddleClick,
            battery: battery.state,
            onOpenBattery: onOpenBattery,
            onOpenNotifications: onOpenNotifications,
            onOpenControlCentre: onOpenControlCentre,
            trash: trash,
            timer: timer,
            isShowingDesktop: desktop.isShowingDesktop,
            onToggleDesktop: onToggleDesktop,
            onBarFrameChange: onBarFrameChange
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
