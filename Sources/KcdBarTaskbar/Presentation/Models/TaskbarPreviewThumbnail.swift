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

import CoreGraphics
import SwiftUI

package struct TaskbarPreviewThumbnail: Identifiable, Equatable {
    package let id: CGWindowID
    package let size: CGSize
    package let image: Image?
    package var displayName: String? = nil
    package var isFullScreen: Bool = false
    package var title: String? = nil
    package var profile: String? = nil

    package var hasCaption: Bool {
        isFullScreen || displayName != nil || !(title ?? "").isEmpty
    }

    package static func thumbnails(
        for windows: [TaskbarPreviewWindow],
        previews: [CGWindowID: WindowPreview]
    ) -> [TaskbarPreviewThumbnail] {
        windows
            .prefix(TaskbarPreviewMetrics.maximumThumbnails)
            .map { window in
                let preview = previews[window.id]
                return TaskbarPreviewThumbnail(
                    id: window.id,
                    size: TaskbarPreviewFit.size(
                        of: preview?.pixelSize ?? window.size,
                        within: TaskbarPreviewMetrics.thumbnailSize
                    ),
                    image: preview?.image,
                    displayName: window.displayName,
                    isFullScreen: window.isFullScreen,
                    title: window.title,
                    profile: window.profile
                )
            }
    }
}
