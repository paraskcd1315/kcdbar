import AppKit
import CoreGraphics
import Observation
import ScreenCaptureKit
import SwiftUI

@MainActor
@Observable
final class ScreenCaptureMenuBarIcons: MenuBarIconPort {
    private var cache: [String: Image] = [:]
    private var captured: [String: CGRect] = [:]

    var isAuthorized: Bool {
        CGPreflightScreenCaptureAccess()
    }

    func requestAuthorization() {
        guard !isAuthorized else { return }

        CGRequestScreenCaptureAccess()
    }

    func icon(for item: MenuBarItem) -> Image? {
        cache[item.id]
    }

    func refresh(items: [MenuBarItem]) async {
        guard isAuthorized else { return }

        for item in items {
            guard let frame = item.frame, captured[item.id] != frame else { continue }
            guard let shot = await Self.capture(frame),
                  let glyph = MenuBarGlyphMask.template(from: shot)
            else {
                continue
            }
            cache[item.id] = Image(nsImage: glyph)
            captured[item.id] = frame
        }
    }

    private nonisolated static func capture(_ frame: CGRect) async -> CGImage? {
        guard let content = try? await SCShareableContent.current,
              let display = content.displays.first(where: { $0.frame.intersects(frame) })
                ?? content.displays.first
        else {
            return nil
        }

        let filter = SCContentFilter(display: display, excludingApplications: [], exceptingWindows: [])
        let configuration = SCStreamConfiguration()
        configuration.sourceRect = frame.offsetBy(dx: -display.frame.minX, dy: -display.frame.minY)
        configuration.width = Int(frame.width * TrayMetrics.glyphScale)
        configuration.height = Int(frame.height * TrayMetrics.glyphScale)
        configuration.showsCursor = false
        configuration.captureResolution = .best

        return try? await SCScreenshotManager.captureImage(
            contentFilter: filter,
            configuration: configuration
        )
    }
}
