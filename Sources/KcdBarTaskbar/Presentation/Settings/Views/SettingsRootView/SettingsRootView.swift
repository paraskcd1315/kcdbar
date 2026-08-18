import SwiftUI

package struct SettingsRootView: View {
    package let settings: BarSettingsState
    package let loginItem: LoginItemState

    @State private var pane: SettingsPane = .appearance

    package init(settings: BarSettingsState, loginItem: LoginItemState) {
        self.settings = settings
        self.loginItem = loginItem
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
            SettingsDetailView(pane: pane, settings: settings, loginItem: loginItem)
                .navigationTitle(pane.title)
        }
        .navigationSplitViewStyle(.balanced)
        .frame(
            minWidth: SettingsMetrics.windowWidth,
            minHeight: SettingsMetrics.windowHeight
        )
    }
}
