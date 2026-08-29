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

import CoreGraphics
import KcdBarTray
import ScreenCaptureKit
import SwiftUI

@MainActor
package final class ScreenCaptureWindowPreviewSource: WindowPreviewPort {
    private var reported: String?
    private let fallback = SkyLightWindowCapture()

    package init() {}

    package func preview(forWindowId windowId: CGWindowID, fitting size: CGSize, onInactiveSpace: Bool) async -> WindowPreview? {
        if onInactiveSpace {
            return fallbackPreview(forWindowId: windowId, fitting: size)
        }
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
