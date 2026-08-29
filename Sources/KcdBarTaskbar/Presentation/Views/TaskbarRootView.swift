import KcdBarTray
import SwiftUI

package struct TaskbarRootView: View {
    package let registry: WindowRegistry
    package let pins: PinnedAppState
    package let order: EntryOrderMemory
    package let desktop: ShowDesktopState
    package let presetState: BarPresetState
    package let displayId: Int
    package let icons: any ApplicationIconPort
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onRequestAccessibility: () -> Void
    package let onOpenStart: () -> Void
    package let onOpenSettings: () -> Void
    package let onOpenAbout: () -> Void
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
    package let totals: TotalsMonitor
    package let sessions: SessionsMonitor
    package let previews: TaskbarPreviewState

    package let onOpenDay: () -> Void
    package let onOpenSessions: () -> Void
    package let onRaiseWindow: (CGWindowID) -> Void
    package let onBarFrameChange: (CGRect) -> Void
    package let onTooltipFrameChange: (CGRect?) -> Void

    package var body: some View {
        TaskbarView(
            viewModel: viewModel,
            onActivate: onActivate,
            onRequestAccessibility: onRequestAccessibility,
            onOpenStart: onOpenStart,
            onOpenSettings: onOpenSettings,
            onOpenAbout: onOpenAbout,
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
            totals: totals,
            sessions: sessions,
            previews: previews,

            onOpenDay: onOpenDay,
            onOpenSessions: onOpenSessions,
            isShowingDesktop: desktop.isShowingDesktop,
            onToggleDesktop: onToggleDesktop,
            onRaiseWindow: onRaiseWindow,
            onBarFrameChange: onBarFrameChange,
            onTooltipFrameChange: onTooltipFrameChange
        )
    }

    private var viewModel: TaskbarViewModel {
        TaskbarViewModel(
            preset: presetState.preset,
            windows: registry.taskbarEntries,
            displayId: displayId,
            displays: registry.displays,
            frontmostPid: registry.frontmostPid,
            bundleIdentifiers: registry.bundleIdentifiers,
            pinnedApps: pins.apps,
            runningApplications: registry.applications,
            ranks: order.ranks,
            hasAccessibility: registry.hasAccessibility,
            icons: icons
        )
    }
}
