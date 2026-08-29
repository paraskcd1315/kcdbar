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

package struct DayHourLines: View {
    package init() {}

    package var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<DayPanelMetrics.hoursInDay, id: \.self) { hour in
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(KbColors.separator)
                        .frame(height: DayPanelMetrics.ruleHeight)
                    Spacer(minLength: 0)
                    Rectangle()
                        .fill(
                            KbColors.separator.opacity(DayPanelMetrics.halfHourOpacity)
                        )
                        .frame(height: DayPanelMetrics.ruleHeight)
                    Spacer(minLength: 0)
                }
                .frame(height: DayPanelMetrics.hourHeight)
                .id(hour)
            }
        }
    }
}
