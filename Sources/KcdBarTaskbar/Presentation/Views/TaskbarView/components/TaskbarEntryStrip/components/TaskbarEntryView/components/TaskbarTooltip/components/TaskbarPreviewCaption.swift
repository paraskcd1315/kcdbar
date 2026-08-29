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

package struct TaskbarPreviewCaption: View {
    package let thumbnail: TaskbarPreviewThumbnail

    package var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title = thumbnail.title, !title.isEmpty {
                HStack(spacing: KbSpacing.s1) {
                    Text(title)
                        .foregroundStyle(KbColors.onSurface)
                    if let profile = thumbnail.profile {
                        Text(verbatim: "·")
                            .foregroundStyle(KbColors.onSurfaceMuted)
                        Text(profile)
                            .foregroundStyle(KbColors.onSurfaceMuted)
                    }
                }
            }
            if thumbnail.isFullScreen || thumbnail.displayName != nil {
                HStack(spacing: KbSpacing.s1) {
                    if thumbnail.isFullScreen {
                        Image(systemName: TaskbarMetrics.fullScreenBadgeSymbol)
                            .font(.system(size: TaskbarMetrics.fullScreenBadgeGlyph, weight: .bold))
                        Text(LocalizedStringKey.catalogue("preview", "fullScreen"))
                    }
                    if let displayName = thumbnail.displayName {
                        if thumbnail.isFullScreen {
                            Text(verbatim: "·")
                        }
                        Text(displayName)
                    }
                }
                .foregroundStyle(KbColors.onSurfaceMuted)
            }
        }
        .font(KbTypography.clockDate)
        .lineLimit(1)
        .padding(.horizontal, KbSpacing.s2)
        .padding(.vertical, KbSpacing.s1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(KbColors.focusedFill)
    }
}
