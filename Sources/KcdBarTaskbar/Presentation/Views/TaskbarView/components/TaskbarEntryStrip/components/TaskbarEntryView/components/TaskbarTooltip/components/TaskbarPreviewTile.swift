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

package struct TaskbarPreviewTile: View {
    package let thumbnail: TaskbarPreviewThumbnail
    package let icon: Image?
    package let onTap: () -> Void
    package let onClose: () -> Void

    @State private var isHovered = false

    package var body: some View {
        ZStack {
            KbColors.bandFill
            if let image = thumbnail.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if let icon {
                icon
                    .resizable()
                    .frame(
                        width: TaskbarPreviewMetrics.fallbackIconSide,
                        height: TaskbarPreviewMetrics.fallbackIconSide
                    )
            }
        }
        .frame(width: thumbnail.size.width, height: thumbnail.size.height)
        .overlay(alignment: .bottom) {
            if thumbnail.hasCaption {
                TaskbarPreviewCaption(thumbnail: thumbnail)
            }
        }
        .clipShape(.rect(cornerRadius: TaskbarPreviewMetrics.thumbnailCornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: TaskbarPreviewMetrics.thumbnailCornerRadius)
                .strokeBorder(
                    isHovered ? KbColors.activeIndicator : KbColors.separator,
                    lineWidth: isHovered ? TaskbarMetrics.openBorderHeight : TaskbarMetrics.separatorThickness
                )
        }
        .overlay(alignment: .topTrailing) {
            if isHovered {
                TaskbarPreviewClose(onClose: onClose)
                    .padding(KbSpacing.s2)
            }
        }
        .contentShape(.rect(cornerRadius: TaskbarPreviewMetrics.thumbnailCornerRadius))
        .onTapGesture(perform: onTap)
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }
}
