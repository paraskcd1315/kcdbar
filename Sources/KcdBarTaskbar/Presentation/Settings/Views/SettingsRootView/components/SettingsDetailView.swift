import SwiftUI

package struct SettingsDetailView: View {
    package let pane: SettingsPane
    package let settings: BarSettingsState
    package let loginItem: LoginItemState
    package let stageManager: StageManagerState
    package let isTrackingAvailable: Bool

    package init(
        pane: SettingsPane,
        settings: BarSettingsState,
        loginItem: LoginItemState,
        stageManager: StageManagerState,
        isTrackingAvailable: Bool
    ) {
        self.pane = pane
        self.settings = settings
        self.loginItem = loginItem
        self.stageManager = stageManager
        self.isTrackingAvailable = isTrackingAvailable
    }

    package var body: some View {
        switch pane {
        case .appearance: AppearancePane(settings: settings)
        case .behaviour:
            BehaviourPane(
                settings: settings,
                loginItem: loginItem,
                stageManager: stageManager,
                isTrackingAvailable: isTrackingAvailable
            )
        }
    }
}
