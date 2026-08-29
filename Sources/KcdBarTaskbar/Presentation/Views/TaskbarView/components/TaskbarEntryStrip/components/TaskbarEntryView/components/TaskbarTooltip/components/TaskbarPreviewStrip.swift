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

import SwiftUI

package struct TaskbarPreviewStrip: View {
    package let thumbnails: [TaskbarPreviewThumbnail]
    package let icon: Image?
    package let onRaiseWindow: (CGWindowID) -> Void
    package let onCloseWindow: (CGWindowID) -> Void

    package var body: some View {
        HStack(spacing: TaskbarPreviewMetrics.thumbnailSpacing) {
            ForEach(thumbnails) { thumbnail in
                TaskbarPreviewTile(
                    thumbnail: thumbnail,
                    icon: icon,
                    onTap: { onRaiseWindow(thumbnail.id) },
                    onClose: { onCloseWindow(thumbnail.id) }
                )
            }
        }
    }
}
