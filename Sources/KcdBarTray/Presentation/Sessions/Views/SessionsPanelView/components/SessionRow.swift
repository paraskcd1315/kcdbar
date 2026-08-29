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

package struct SessionRow: View {
    package let session: ClaudeSession
    package let now: Date
    package let onFocus: (ClaudeSession) -> Void

    @State private var isHovering = false

    package init(
        session: ClaudeSession,
        now: Date,
        onFocus: @escaping (ClaudeSession) -> Void
    ) {
        self.session = session
        self.now = now
        self.onFocus = onFocus
    }

    package var body: some View {
        HStack(alignment: .top, spacing: KbSpacing.s4) {
            SessionRowDot(session: session)
                .padding(.top, KbSpacing.s2)

            VStack(alignment: .leading, spacing: KbSpacing.s1) {
                SessionRowTitle(session: session)
                SessionRowLine(session: session, now: now)
            }
        }
        .padding(.vertical, KbSpacing.s2)
        .padding(.horizontal, KbSpacing.s3)
        .background(background, in: shape)
        .kbTappable(in: shape, perform: focus)
        .onHover { isHovering = $0 }
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.sm, style: .continuous)
    }

    private var background: Color {
        isHovering && session.hasPane ? KbColors.separator : .clear
    }

    private func focus() {
        guard session.hasPane else { return }

        onFocus(session)
    }
}
