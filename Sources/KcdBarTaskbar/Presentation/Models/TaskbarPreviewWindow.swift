import CoreGraphics

/** One window an entry can preview — its id, and the size its thumbnail keeps the shape of. */
package struct TaskbarPreviewWindow: Identifiable, Equatable, Sendable {
    package let id: CGWindowID
    package let size: CGSize

    package init(id: CGWindowID, size: CGSize) {
        self.id = id
        self.size = size
    }
}
