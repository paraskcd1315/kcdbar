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

package struct SessionsPanelSurface: View {
    package let sessions: [ClaudeSession]
    package let arrowX: CGFloat
    package let onFocus: (ClaudeSession) -> Void

    package init(
        sessions: [ClaudeSession],
        arrowX: CGFloat,
        onFocus: @escaping (ClaudeSession) -> Void
    ) {
        self.sessions = sessions
        self.arrowX = arrowX
        self.onFocus = onFocus
    }

    package var body: some View {
        TimelineView(.periodic(from: .now, by: SessionsPanelMetrics.tick)) { context in
            VStack(alignment: .leading, spacing: KbSpacing.s5) {
                SessionsPanelHeader(count: sessions.count)
                Rectangle()
                    .fill(KbColors.separator)
                    .frame(height: KbPopoverMetrics.dividerHeight)

                if sessions.isEmpty {
                    Text("sessions.none")
                        .font(KbTypography.panelDetail)
                        .foregroundStyle(KbColors.onSurfaceMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, KbSpacing.s6)
                } else {
                    SessionsPanelList(
                        sessions: sessions, now: context.date, onFocus: onFocus)
                }
            }
            .padding(.horizontal, KbSpacing.s6)
            .padding(.top, KbSpacing.s6)
            .padding(.bottom, KbSpacing.s6 + KbPopoverMetrics.arrowSize.height)
        }
        .frame(width: SessionsReadoutMetrics.panelWidth, alignment: .leading)
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: arrowX))
        .overlay { KbPopoverEdge(arrowX: arrowX) }
    }
}
