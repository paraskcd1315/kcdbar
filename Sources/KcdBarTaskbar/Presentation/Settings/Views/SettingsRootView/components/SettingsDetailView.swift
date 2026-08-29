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
