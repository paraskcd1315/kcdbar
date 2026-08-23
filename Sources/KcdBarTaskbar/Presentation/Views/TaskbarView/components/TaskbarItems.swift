import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

package struct TaskbarItems: View {
    package let viewModel: TaskbarViewModel
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onOpenStart: () -> Void
    package let onOpenSettings: () -> Void
    package let onOpenAbout: () -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onCloseWindow: (TaskbarEntryModel) -> Void
    package let onQuit: (TaskbarEntryModel) -> Void
    package let onDropPin: (String, TaskbarEntryModel) -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void
    package let battery: BatteryState
    package let onOpenBattery: () -> Void
    package let onOpenNotifications: () -> Void
    package let onOpenControlCentre: () -> Void
    package let trash: TrashMonitor
    package let timer: TimerMonitor
    package let totals: TotalsMonitor
    package let sessions: SessionsMonitor
    package let onOpenDay: () -> Void
    package let onOpenSessions: () -> Void

    package var body: some View {
        KbAxisStack(isVertical: viewModel.preset.edge.isVertical, spacing: viewModel.preset.entrySpacing) {
            if viewModel.preset.startButton == .leading {
                TaskbarStartButton(
                    mark: viewModel.preset.startMark,
                    iconSize: BarEntryMetrics.iconSize(for: viewModel.preset),
                    cornerRadius: viewModel.preset.entryCornerRadius,
                    isVertical: viewModel.preset.edge.isVertical,
                    side: BarEntryMetrics.itemSide(for: viewModel.preset),
                    onOpen: onOpenStart,
                    onOpenSettings: onOpenSettings,
                    onOpenAbout: onOpenAbout
                )
            }
            TaskbarLaunchGroup(
                viewModel: viewModel,
                onActivate: onActivate,
                onOpenStart: onOpenStart,
                onOpenSettings: onOpenSettings,
                onOpenAbout: onOpenAbout,
                onTogglePin: onTogglePin,
                onCloseWindow: onCloseWindow,
                onQuit: onQuit,
                onDropPin: onDropPin,
                onMiddleClick: onMiddleClick
            )
            if viewModel.preset.showsTrash {
                TaskbarSeparator(isVertical: viewModel.preset.edge.isVertical)
                TaskbarTrash(
                    monitor: trash,
                    iconSize: BarEntryMetrics.iconSize(for: viewModel.preset),
                    isVertical: viewModel.preset.edge.isVertical,
                    side: BarEntryMetrics.itemSide(for: viewModel.preset)
                )
            }
            if showsStatusArea {
                TaskbarSeparator(isVertical: viewModel.preset.edge.isVertical)
            }
            if viewModel.preset.showsBattery, battery.isPresent {
                TaskbarBattery(state: battery, onOpen: onOpenBattery)
            }
            if viewModel.preset.showsControlCentre {
                TaskbarControlCentreButton(onOpen: onOpenControlCentre)
            }
            if viewModel.preset.showsClock {
                TaskbarClock(onOpen: onOpenNotifications)
            }
            if viewModel.preset.showsTracking, sessions.isAvailable {
                TaskbarSessions(monitor: sessions, onOpen: onOpenSessions)
            }
            if viewModel.preset.showsTracking, timer.isAvailable {
                TaskbarTracking(timer: timer, totals: totals, onOpenDay: onOpenDay)
            }
        }
    }

    private var showsStatusArea: Bool {
        TaskbarStatusVisibility.showsAnything(
            preset: viewModel.preset,
            hasBattery: battery.isPresent,
            hasTracking: timer.isAvailable
        )
    }
}
