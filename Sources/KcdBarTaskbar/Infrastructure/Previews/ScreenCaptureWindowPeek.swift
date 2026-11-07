// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import AppKit
import KcdBarTray
import ScreenCaptureKit

/** A peek drawn from one capture per display of its desktop-level windows plus the target window. */
@MainActor
package final class ScreenCaptureWindowPeek: WindowPeekPort {
    private var overlays: [Int: WindowPeekOverlayPanel] = [:]
    private var generation = 0
    private var reported: String?

    package init() {}

    package func show(_ target: WindowPeekTarget, onDisplays displayIds: [Int]) async {
        generation += 1
        let current = generation
        let pictures = await capture(target, onDisplays: displayIds)
        guard current == generation else { return }

        for (displayId, overlay) in overlays where pictures[displayId] == nil {
            overlay.dismiss()
        }
        for (displayId, image) in pictures {
            guard let screen = NSScreen.screens.first(where: { $0.displayNumber == displayId }) else { continue }

            let overlay = overlays[displayId] ?? WindowPeekOverlayPanel(frame: screen.frame)
            overlays[displayId] = overlay
            overlay.present(image, on: screen.frame)
        }
    }

    package func hide() {
        generation += 1
        for overlay in overlays.values {
            overlay.dismiss()
        }
    }

    private func capture(_ target: WindowPeekTarget, onDisplays displayIds: [Int]) async -> [Int: CGImage] {
        do {
            let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
            let desktop = content.windows.filter { $0.windowLayer < WindowPeekMetrics.desktopLayerCeiling }
            let peeked = content.windows.first { window in
                if case .window(let windowId) = target { return window.windowID == windowId }
                return false
            }
            if case .window = target, peeked == nil {
                report("absent")
                return [:]
            }
            var pictures: [Int: CGImage] = [:]
            for display in content.displays where displayIds.contains(Int(display.displayID)) {
                let included = (desktop + [peeked].compactMap { $0 }).filter { $0.frame.intersects(display.frame) }
                pictures[Int(display.displayID)] = try await SCScreenshotManager.captureImage(
                    contentFilter: SCContentFilter(display: display, including: included),
                    configuration: configuration(for: display)
                )
            }
            report("captured")

            return pictures
        } catch {
            report("refused code=\((error as NSError).code)")

            return [:]
        }
    }

    private func configuration(for display: SCDisplay) -> SCStreamConfiguration {
        let scale = NSScreen.screens
            .first { $0.displayNumber == Int(display.displayID) }?
            .backingScaleFactor ?? 1
        let configuration = SCStreamConfiguration()
        configuration.width = Int(CGFloat(display.width) * scale)
        configuration.height = Int(CGFloat(display.height) * scale)
        configuration.showsCursor = false

        return configuration
    }

    private func report(_ outcome: String) {
        guard reported != outcome else { return }

        reported = outcome
        BarLog.bar.notice("peek \(outcome, privacy: .public)")
    }
}
