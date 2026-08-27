import SwiftUI

package struct SettingsDetailView: View {
    package let pane: SettingsPane
    package let settings: BarSettingsState
    package let loginItem: LoginItemState
    package let stageManager: StageManagerState
    package let exclusions: QuitExclusionState
    package let runningApplications: [RunningApplication]
    package let isTrackingAvailable: Bool

    package init(
        pane: SettingsPane,
        settings: BarSettingsState,
        loginItem: LoginItemState,
        stageManager: StageManagerState,
        exclusions: QuitExclusionState,
        runningApplications: [RunningApplication],
        isTrackingAvailable: Bool
    ) {
        self.pane = pane
        self.settings = settings
        self.loginItem = loginItem
        self.stageManager = stageManager
        self.exclusions = exclusions
        self.runningApplications = runningApplications
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
                exclusions: exclusions,
                runningApplications: runningApplications,
                isTrackingAvailable: isTrackingAvailable
            )
        }
    }
}
