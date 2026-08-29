import CoreGraphics
import SwiftUI

@testable import KcdBarTaskbar

@MainActor
final class StubWindowPreviews: WindowPreviewPort {
    private(set) var asked: [CGWindowID] = []
    var capturable: Set<CGWindowID> = []

    func preview(forWindowId windowId: CGWindowID, fitting size: CGSize) async -> WindowPreview? {
        asked.append(windowId)
        guard capturable.contains(windowId) else { return nil }

        return WindowPreview(image: Image(systemName: "rectangle"), pixelSize: CGSize(width: 320, height: 200))
    }
}
