import SwiftUI

package struct SettingsRootView: View {
    package let settings: BarSettingsState
    package let loginItem: LoginItemState
    package let stageManager: StageManagerState

    @State private var pane: SettingsPane = .appearance

    package init(settings: BarSettingsState, loginItem: LoginItemState, stageManager: StageManagerState) {
        self.settings = settings
        self.loginItem = loginItem
        self.stageManager = stageManager
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
                stageManager: stageManager
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
