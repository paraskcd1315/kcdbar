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

package struct SessionRowLine: View {
    package let session: ClaudeSession
    package let now: Date

    package init(session: ClaudeSession, now: Date) {
        self.session = session
        self.now = now
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s2) {
            if session.isBlocked {
                Text("sessions.waitingOnYou")
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(KbColors.batteryWarning)

                if let reason = session.waitingFor, !reason.isEmpty {
                    Text(reason)
                        .font(KbTypography.trackingLabel)
                        .foregroundStyle(KbColors.onSurfaceMuted)
                        .lineLimit(1)
                }
            } else {
                Text(doing)
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            if let context = session.context {
                Text(SessionsFormatting.share(context))
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(context.isTight ? KbColors.batteryWarning : KbColors.onSurfaceMuted)
                    .monospacedDigit()
            }
        }
    }

    private var doing: String {
        if let doing = session.doing, !doing.isEmpty { return doing }

        guard let quiet = session.quietFor(at: now) else { return standing }

        return "\(standing) · \(SessionsFormatting.quiet(quiet))"
    }

    private var standing: String {
        guard let standing = session.standing else { return "" }

        return SessionsCopy.standing(standing)
    }
}
