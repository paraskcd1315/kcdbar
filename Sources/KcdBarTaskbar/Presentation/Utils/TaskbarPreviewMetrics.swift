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

package enum TaskbarPreviewMetrics {
    package static let thumbnailWidth: CGFloat = 168
    package static let thumbnailHeight: CGFloat = 104
    package static let thumbnailSpacing: CGFloat = 6
    package static let thumbnailCornerRadius: CGFloat = 6
    package static let maximumThumbnails = 4
    package static let captureScale: CGFloat = 2
    package static let fallbackIconSide: CGFloat = 48

    package static var thumbnailSize: CGSize {
        CGSize(width: thumbnailWidth, height: thumbnailHeight)
    }

    package static func captureSize(for tile: CGSize) -> CGSize {
        CGSize(width: tile.width * captureScale, height: tile.height * captureScale)
    }

    package static var panelAllowance: CGFloat {
        TaskbarMetrics.tooltipAllowance + thumbnailHeight + thumbnailSpacing
    }
}
