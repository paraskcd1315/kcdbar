import AppKit
import CoreGraphics
import Observation
import ScreenCaptureKit
import SwiftUI

@MainActor
@Observable
final class ScreenCaptureMenuBarIcons: MenuBarIconPort {
    private var cache: [String: Image] = [:]
    private var attempted: Set<String> = []
    private var isCapturing = false

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
        guard isAuthorized, !isCapturing else { return }

        let wanted = items.filter { !attempted.contains($0.id) && $0.frame != nil }
        guard !wanted.isEmpty else { return }

        isCapturing = true
        defer { isCapturing = false }

        wanted.forEach { attempted.insert($0.id) }
        let frames = wanted.compactMap { item in item.frame.map { (item.id, $0) } }

        for (id, shot) in await Self.captureAll(frames) {
            guard let glyph = MenuBarGlyphMask.template(from: shot) else { continue }
            cache[id] = Image(nsImage: glyph)
        }
    }

    func forget() {
        cache = [:]
        attempted = []
    }

    private nonisolated static func captureAll(_ frames: [(String, CGRect)]) async -> [(String, CGImage)] {
        guard let content = try? await SCShareableContent.current else { return [] }

        var results: [(String, CGImage)] = []
        for (id, frame) in frames {
            guard let display = content.displays.first(where: { $0.frame.intersects(frame) })
                ?? content.displays.first,
                let shot = await capture(frame, on: display)
            else {
                continue
            }
            results.append((id, shot))
        }

        return results
    }

    private nonisolated static func capture(_ frame: CGRect, on display: SCDisplay) async -> CGImage? {
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
