import SwiftUI

package struct SettingsRootView: View {
    package let settings: BarSettingsState
    package let loginItem: LoginItemState
    package let stageManager: StageManagerState
    package let exclusions: QuitExclusionState
    package let runningApplications: [RunningApplication]
    package let isTrackingAvailable: Bool

    @State private var pane: SettingsPane = .appearance

    package init(
        settings: BarSettingsState,
        loginItem: LoginItemState,
        stageManager: StageManagerState,
        exclusions: QuitExclusionState,
        runningApplications: [RunningApplication],
        isTrackingAvailable: Bool
    ) {
        self.settings = settings
        self.loginItem = loginItem
        self.stageManager = stageManager
        self.exclusions = exclusions
        self.runningApplications = runningApplications
        self.isTrackingAvailable = isTrackingAvailable
    }

    package var body: some View {
        NavigationSplitView {
            List(selection: $pane) {
                ForEach(SettingsPane.allCases) { pane in
                    SettingsPaneLink(pane: pane).tag(pane)
                }
            }
            .navigationSplitViewColumnWidth(
                min: SettingsMetrics.sidebarMinWidth,
                ideal: SettingsMetrics.sidebarWidth,
                max: SettingsMetrics.sidebarMaxWidth
            )
        } detail: {
            SettingsDetailView(
                pane: pane,
                settings: settings,
                loginItem: loginItem,
                stageManager: stageManager,
                exclusions: exclusions,
                runningApplications: runningApplications,
                isTrackingAvailable: isTrackingAvailable
            )
                .navigationTitle(pane.title)
        }
        .navigationSplitViewStyle(.balanced)
        .frame(
            minWidth: SettingsMetrics.windowWidth,
            minHeight: SettingsMetrics.windowHeight
        )
    }
}
