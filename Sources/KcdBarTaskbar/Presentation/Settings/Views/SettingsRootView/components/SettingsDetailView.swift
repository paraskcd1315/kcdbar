import SwiftUI

package struct SettingsDetailView: View {
    package let pane: SettingsPane
    package let settings: BarSettingsState
    package let loginItem: LoginItemState

    package init(pane: SettingsPane, settings: BarSettingsState, loginItem: LoginItemState) {
        self.pane = pane
        self.settings = settings
        self.loginItem = loginItem
    }

    package var body: some View {
        switch pane {
        case .appearance: AppearancePane(settings: settings)
        case .behaviour: BehaviourPane(settings: settings, loginItem: loginItem)
        }
    }
}
