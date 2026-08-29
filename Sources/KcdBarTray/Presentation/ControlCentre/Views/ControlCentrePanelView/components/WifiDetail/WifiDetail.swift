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
import SwiftUI

package struct WifiDetail: View {
    package let monitor: WifiMonitor
    package let onBack: () -> Void
    package let onCopy: (String) -> Void
    package let onOpenSettings: () -> Void

    @State private var showsOther = false

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            ControlCentreDetailHeader(
                titleKey: "wifi.title",
                isOn: monitor.state.isPowered,
                onBack: onBack,
                onSetPower: { monitor.setPower($0) }
            )
            if monitor.state.isPowered {
                WifiKnownList(networks: monitor.inRange)
                WifiDisclosureRow(titleKey: "wifi.section.other", isExpanded: showsOther) {
                    withAnimation(KbMotion.standard) { showsOther.toggle() }
                    guard showsOther else { return }

                    Task { await monitor.scan() }
                }
                if showsOther {
                    WifiOtherList(monitor: monitor)
                }
                if let detail = monitor.detail {
                    ControlCentreAccordion(titleKey: "network.details") {
                        NetworkDetailList(detail: detail, onCopy: onCopy)
                    }
                }
            }
            ControlCentreSettingsRow(titleKey: "wifi.settings", onOpen: onOpenSettings)
        }
        .task { await monitor.scan() }
    }
}
