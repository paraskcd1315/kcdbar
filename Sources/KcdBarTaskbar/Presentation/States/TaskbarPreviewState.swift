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
                fitting: TaskbarPreviewMetrics.captureSize(for: tile)
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
