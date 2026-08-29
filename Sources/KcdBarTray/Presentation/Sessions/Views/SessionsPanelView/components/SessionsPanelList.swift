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

package struct SessionsPanelList: View {
    package let sessions: [ClaudeSession]
    package let now: Date
    package let onFocus: (ClaudeSession) -> Void

    package init(
        sessions: [ClaudeSession],
        now: Date,
        onFocus: @escaping (ClaudeSession) -> Void
    ) {
        self.sessions = sessions
        self.now = now
        self.onFocus = onFocus
    }

    package var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: SessionsReadoutMetrics.rowSpacing) {
                ForEach(sessions) { session in
                    SessionRow(session: session, now: now, onFocus: onFocus)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxHeight: SessionsReadoutMetrics.listMaxHeight)
    }
}
