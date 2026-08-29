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

package struct TaskbarTooltip: View {
    package let applicationName: String
    package let windowTitle: String
    package let thumbnails: [TaskbarPreviewThumbnail]
    package let icon: Image?
    package let onRaiseWindow: (CGWindowID) -> Void
    package let onCloseWindow: (CGWindowID) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            if !thumbnails.isEmpty {
                TaskbarPreviewStrip(
                    thumbnails: thumbnails,
                    icon: icon,
                    onRaiseWindow: onRaiseWindow,
                    onCloseWindow: onCloseWindow
                )
            }
            VStack(alignment: .leading, spacing: KbSpacing.s1) {
                Text(applicationName)
                    .font(KbTypography.entryTitleActive)
                    .foregroundStyle(KbColors.onSurface)
                if showsWindowTitle {
                    Text(windowTitle)
                        .font(KbTypography.entryTitle)
                        .foregroundStyle(KbColors.onSurfaceMuted)
                }
            }
            .lineLimit(1)
            .frame(maxWidth: TaskbarMetrics.tooltipMaxWidth, alignment: .leading)
        }
        .padding(.horizontal, KbSpacing.s5)
        .padding(.vertical, KbSpacing.s3)
        .fixedSize()
        .glassEffect(.regular, in: .rect(cornerRadius: KbRadii.md))
        .shadow(
            color: KbColors.scrim,
            radius: TaskbarMetrics.tooltipShadowRadius,
            y: TaskbarMetrics.tooltipShadowOffset
        )
    }

    private var showsWindowTitle: Bool {
        !windowTitle.isEmpty && windowTitle != applicationName
    }
}
