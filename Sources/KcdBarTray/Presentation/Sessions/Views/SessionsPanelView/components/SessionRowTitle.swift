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

package struct SessionRowTitle: View {
    package let session: ClaudeSession

    package init(session: ClaudeSession) {
        self.session = session
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s2) {
            Text(session.title)
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
                .lineLimit(1)
                .truncationMode(.middle)

            if session.isTerminal {
                Text("sessions.terminal")
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }

            if let project = session.project {
                Text(project)
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
    }
}
