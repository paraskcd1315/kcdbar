import CoreGraphics
import KcdBarTray
import ScreenCaptureKit
import SwiftUI

@MainActor
package final class ScreenCaptureWindowPreviewSource: WindowPreviewPort {
    private var reported: String?

    package init() {}

    package func preview(forWindowId windowId: CGWindowID, fitting size: CGSize) async -> Image? {
        do {
            let content = try await SCShareableContent.excludingDesktopWindows(
                true,
                onScreenWindowsOnly: true
            )
            guard let window = content.windows.first(where: { $0.windowID == windowId }) else {
                report("absent")
                return nil
            }
            let image = try await SCScreenshotManager.captureImage(
                contentFilter: SCContentFilter(desktopIndependentWindow: window),
                configuration: configuration(fitting: size)
            )
            report("captured")

            return Image(decorative: image, scale: 1)
        } catch {
            report("refused code=\((error as NSError).code)")

            return nil
        }
    }

    private func configuration(fitting size: CGSize) -> SCStreamConfiguration {
        let configuration = SCStreamConfiguration()
        configuration.width = Int(size.width)
        configuration.height = Int(size.height)
        configuration.scalesToFit = true
        configuration.showsCursor = false

        return configuration
    }

    private func report(_ outcome: String) {
        guard reported != outcome else { return }

        reported = outcome
        BarLog.bar.notice("preview \(outcome, privacy: .public)")
    }
}
