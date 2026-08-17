import SwiftUI

package struct SettingsRootView: View {
    package let settings: BarSettingsState
    package let loginItem: LoginItemState

    package init(settings: BarSettingsState, loginItem: LoginItemState) {
        self.settings = settings
        self.loginItem = loginItem
    }

    package var body: some View {
        NavigationStack {
            List(SettingsPane.allCases) { pane in
                NavigationLink {
                    destination(for: pane)
                        .navigationTitle(pane.title)
                } label: {
                    SettingsPaneLink(pane: pane)
                }
            }
            .navigationTitle("settings.title")
        }
        .frame(
            minWidth: SettingsMetrics.windowWidth,
            minHeight: SettingsMetrics.windowHeight
        )
    }

    @ViewBuilder
    private func destination(for pane: SettingsPane) -> some View {
        switch pane {
        case .appearance: AppearancePane(settings: settings)
        case .behaviour: BehaviourPane(settings: settings, loginItem: loginItem)
        }
    }
}
