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
import Observation
import SwiftUI

/** The thumbnails for the entry the pointer rests on, one per window. */
@MainActor
@Observable
package final class TaskbarPreviewState {
    package private(set) var previews: [CGWindowID: WindowPreview] = [:]

    @ObservationIgnored private let port: any WindowPreviewPort
    @ObservationIgnored private var requested: Set<CGWindowID> = []

    package init(port: any WindowPreviewPort) {
        self.port = port
    }

    package func load(_ windows: [TaskbarPreviewWindow]) async {
        let wanted = Array(windows.prefix(TaskbarPreviewMetrics.maximumThumbnails))
        requested = Set(wanted.map(\.id))
        previews = previews.filter { requested.contains($0.key) }

        for window in wanted where previews[window.id] == nil {
            let tile = TaskbarPreviewFit.size(of: window.size, within: TaskbarPreviewMetrics.thumbnailSize)
            let image = await port.preview(
                forWindowId: window.id,
                fitting: TaskbarPreviewMetrics.captureSize(for: tile),
                onInactiveSpace: window.isOnInactiveSpace
            )
            guard requested.contains(window.id) else { return }
            guard let image else { continue }

            previews[window.id] = image
        }
    }

    package func clear() {
        requested = []
        previews = [:]
    }
}
