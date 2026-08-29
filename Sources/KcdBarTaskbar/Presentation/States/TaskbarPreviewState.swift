import CoreGraphics
import Observation
import SwiftUI

/** The thumbnails for the entry the pointer rests on, one per window. */
@MainActor
@Observable
package final class TaskbarPreviewState {
    package private(set) var previews: [CGWindowID: Image] = [:]

    @ObservationIgnored private let port: any WindowPreviewPort
    @ObservationIgnored private var requested: Set<CGWindowID> = []

    package init(port: any WindowPreviewPort) {
        self.port = port
    }

    package func load(_ windowIds: [CGWindowID]) async {
        let wanted = Array(windowIds.prefix(TaskbarPreviewMetrics.maximumThumbnails))
        requested = Set(wanted)
        previews = previews.filter { requested.contains($0.key) }

        for windowId in wanted where previews[windowId] == nil {
            let image = await port.preview(
                forWindowId: windowId,
                fitting: TaskbarPreviewMetrics.captureSize
            )
            guard requested.contains(windowId) else { return }
            guard let image else { continue }

            previews[windowId] = image
        }
    }

    package func clear() {
        requested = []
        previews = [:]
    }
}
