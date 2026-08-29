import CoreGraphics

/** One window an entry can preview — its id, the size its thumbnail keeps the shape of, and what the tile says about it. */
package struct TaskbarPreviewWindow: Identifiable, Equatable, Sendable {
    package let id: CGWindowID
    package let size: CGSize
    package var displayName: String? = nil
    package var isFullScreen: Bool = false

    package init(id: CGWindowID, size: CGSize, displayName: String? = nil, isFullScreen: Bool = false) {
        self.id = id
        self.size = size
        self.displayName = displayName
        self.isFullScreen = isFullScreen
    }
}
