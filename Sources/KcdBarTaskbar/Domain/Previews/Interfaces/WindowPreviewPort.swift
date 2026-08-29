import CoreGraphics
import SwiftUI

/** A thumbnail of one window, or nothing when the system will not give one. */
@MainActor
package protocol WindowPreviewPort {
    func preview(forWindowId windowId: CGWindowID, fitting size: CGSize) async -> WindowPreview?
}
