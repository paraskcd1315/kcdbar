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

package struct DayEntryBlockTitle: View {
    package let entry: DayEntry
    package let tone: Color

    package init(entry: DayEntry, tone: Color) {
        self.entry = entry
        self.tone = tone
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s1) {
            Text(DayFormatting.label(for: entry))
                .font(KbTypography.trackingLabel)
                .foregroundStyle(KbColors.onSurface)
                .lineLimit(1)
                .truncationMode(.tail)

            if entry.isBillable {
                Image(systemName: DayPanelMetrics.billableSymbol)
                    .font(.system(size: DayPanelMetrics.glyphSide))
                    .foregroundStyle(KbColors.batteryFull)
            }

            if entry.opensATicket {
                Image(systemName: DayPanelMetrics.openSymbol)
                    .font(.system(size: DayPanelMetrics.glyphSide))
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }

            Spacer(minLength: 0)
        }
    }
}
