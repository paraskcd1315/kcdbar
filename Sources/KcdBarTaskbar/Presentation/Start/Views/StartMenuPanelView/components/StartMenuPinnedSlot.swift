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

package struct StartMenuPinnedSlot<Content: View>: View {
    package let isShown: Bool
    @ViewBuilder package let content: () -> Content

    @State private var isExpanded = false
    @State private var showsContent = false

    package var body: some View {
        HStack(alignment: .top, spacing: 0) {
            StartMenuPaneDivider()
            content()
                .frame(width: StartMenuMetrics.pinnedPaneWidth, alignment: .leading)
                .opacity(showsContent ? 1 : 0)
                .scaleEffect(
                    showsContent ? 1 : StartMenuMetrics.pinnedRevealScale,
                    anchor: .leading
                )
        }
        .frame(width: isExpanded ? slotWidth : 0, alignment: .leading)
        .clipped()
        .onAppear {
            isExpanded = isShown
            showsContent = isShown
        }
        .onChange(of: isShown) { _, shown in
            guard shown else {
                withAnimation(KbMotion.quick) { showsContent = false } completion: {
                    isExpanded = false
                }
                return
            }
            isExpanded = true
            withAnimation(KbMotion.standard.delay(KbMotion.standardDuration)) {
                showsContent = true
            }
        }
    }

    private var slotWidth: CGFloat {
        StartMenuMetrics.pinnedPaneWidth + KbEdgeMetrics.width
    }
}
