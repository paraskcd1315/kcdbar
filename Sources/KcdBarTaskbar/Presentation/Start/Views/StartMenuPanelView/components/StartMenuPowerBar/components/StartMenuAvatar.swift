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

package struct StartMenuAvatar: View {
    package let image: Image?

    package var body: some View {
        Group {
            if let image {
                image.resizable().interpolation(.high)
            } else {
                Image(systemName: StartMenuMetrics.avatarGlyph)
                    .resizable()
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: StartMenuMetrics.avatarSize, height: StartMenuMetrics.avatarSize)
        .clipShape(Circle())
        .overlay(Circle().stroke(KbColors.separator, lineWidth: KbEdgeMetrics.width))
    }
}
