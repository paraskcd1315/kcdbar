// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

package struct TaskbarBody: View {
    package let viewModel: TaskbarViewModel
    package let isShowingDesktop: Bool
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onRequestAccessibility: () -> Void
    package let onOpenStart: () -> Void
    package let onOpenSettings: () -> Void
    package let onOpenAbout: () -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onCloseWindow: (TaskbarEntryModel) -> Void
    package let onQuit: (TaskbarEntryModel) -> Void
    package let onDropPin: (String, TaskbarEntryModel) -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void
    package let onCycle: (TaskbarEntryModel) -> Void
    package let battery: BatteryState
    package let onOpenBattery: () -> Void
    package let onOpenNotifications: () -> Void
    package let onOpenControlCentre: () -> Void
    package let trash: TrashMonitor
    package let timer: TimerMonitor
    package let totals: TotalsMonitor
    package let sessions: SessionsMonitor
    package let console: any ConsolePopoverPort
    package let icon: any ConsoleIconPort

    package let onOpenDay: () -> Void
    package let onOpenSessions: () -> Void
    package let onOpenConsole: () -> Void
    package let onToggleDesktop: () -> Void

    package var body: some View {
        KbAxisStack(isVertical: viewModel.preset.edge.isVertical, spacing: 0) {
            TaskbarContentArea(
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
                onCycle: onCycle,
                battery: battery,
                onOpenBattery: onOpenBattery,
                onOpenNotifications: onOpenNotifications,
                onOpenControlCentre: onOpenControlCentre,
                trash: trash,
                timer: timer,
                totals: totals,
                sessions: sessions,
                console: console,
                icon: icon,
                onOpenDay: onOpenDay,
                onOpenSessions: onOpenSessions,
                onOpenConsole: onOpenConsole
            )
            if showsDesktopCap {
                TaskbarDesktopCap(
                    preset: viewModel.preset,
                    isShowingDesktop: isShowingDesktop,
                    onToggle: onToggleDesktop
                )
                .padding(
                    viewModel.preset.edge.isVertical ? .top : .leading,
                    TaskbarMetrics.trayEndPadding
                )
            }
        }
        .frame(
            maxWidth: TaskbarBarLayout.fillsCrossAxis(.horizontal, preset: viewModel.preset)
                ? .infinity
                : nil,
            maxHeight: TaskbarBarLayout.fillsCrossAxis(.vertical, preset: viewModel.preset)
                ? .infinity
                : nil
        )
    }

    private var showsDesktopCap: Bool {
        viewModel.preset.showsDesktopButton && viewModel.notice == nil
    }
}
