import CoreGraphics
import KcdBarTray
import ScreenCaptureKit
import SwiftUI

@MainActor
package final class ScreenCaptureWindowPreviewSource: WindowPreviewPort {
    private var reported: String?
    private let fallback = SkyLightWindowCapture()

    package init() {}

    package func preview(forWindowId windowId: CGWindowID, fitting size: CGSize) async -> WindowPreview? {
        do {
            let content = try await SCShareableContent.excludingDesktopWindows(
                true,
                onScreenWindowsOnly: false
            )
            guard let window = content.windows.first(where: { $0.windowID == windowId }) else {
                report("absent")
                return fallbackPreview(forWindowId: windowId, fitting: size)
            }
            let image = try await SCScreenshotManager.captureImage(
                contentFilter: SCContentFilter(desktopIndependentWindow: window),
                configuration: configuration(fitting: size)
            )
            report("captured")

            return WindowPreview(
                image: Image(decorative: image, scale: 1),
                pixelSize: CGSize(width: image.width, height: image.height)
            )
        } catch {
            report("refused code=\((error as NSError).code)")

            return fallbackPreview(forWindowId: windowId, fitting: size)
        }
    }

    private func fallbackPreview(forWindowId windowId: CGWindowID, fitting size: CGSize) -> WindowPreview? {
        guard let image = fallback.capture(windowId: windowId, fitting: size) else { return nil }
        report("captured privately")

        return WindowPreview(
            image: Image(decorative: image, scale: 1),
            pixelSize: CGSize(width: image.width, height: image.height)
        )
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
