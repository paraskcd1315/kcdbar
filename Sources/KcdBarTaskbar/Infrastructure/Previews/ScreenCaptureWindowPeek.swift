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
import IOSurface
import KcdBarTray
import ScreenCaptureKit

/** A live peek: one stream per display of its desktop-level windows and the peeked window. */
@MainActor
package final class ScreenCaptureWindowPeek: WindowPeekPort {
    private var overlays: [Int: WindowPeekOverlayPanel] = [:]
    private var streams: [SCStream] = []
    private var outputs: [WindowPeekStreamOutput] = []
    private var generation = 0
    private var reported: String?

    package init() {}

    package func show(_ target: WindowPeekTarget, in scenes: [WindowPeekScene]) async {
        generation += 1
        let current = generation
        let content: SCShareableContent
        do {
            content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
        } catch {
            report("refused code=\((error as NSError).code)")
            return
        }
        guard current == generation else { return }

        let desktop = content.windows.filter { $0.windowLayer < WindowPeekMetrics.desktopLayerCeiling }
        let peeked = content.windows.first { window in
            if case .window(let windowId) = target { return window.windowID == windowId }
            return false
        }
        if case .window = target, peeked == nil {
            report("absent")
            hide()
            return
        }

        stopStreams()
        let wanted = Set(scenes.map(\.displayId))
        for (displayId, overlay) in overlays where !wanted.contains(displayId) {
            overlay.dismiss()
        }
        for scene in scenes {
            guard let display = content.displays.first(where: { Int($0.displayID) == scene.displayId }) else {
                continue
            }
            let included = (desktop + [peeked].compactMap { $0 }).filter { $0.frame.intersects(display.frame) }
            await start(
                SCContentFilter(display: display, including: included),
                configuration: configuration(for: display),
                scene: scene,
                generation: current
            )
            guard current == generation else { return }
        }
    }

    package func hide() {
        generation += 1
        stopStreams()
        for overlay in overlays.values {
            overlay.dismiss()
        }
    }

    private func start(
        _ filter: SCContentFilter,
        configuration: SCStreamConfiguration,
        scene: WindowPeekScene,
        generation started: Int
    ) async {
        let output = WindowPeekStreamOutput { [weak self] surface in
            self?.draw(surface, scene: scene, generation: started)
        }
        let stream = SCStream(filter: filter, configuration: configuration, delegate: nil)
        do {
            try stream.addStreamOutput(output, type: .screen, sampleHandlerQueue: .main)
            streams.append(stream)
            outputs.append(output)
            try await stream.startCapture()
            report("streaming")
        } catch {
            report("refused code=\((error as NSError).code)")
        }
        if started != generation {
            try? await stream.stopCapture()
        }
    }

    private func draw(_ surface: IOSurfaceRef, scene: WindowPeekScene, generation drawn: Int) {
        guard drawn == generation,
              let screen = NSScreen.screens.first(where: { $0.displayNumber == scene.displayId })
        else {
            return
        }
        let overlay = overlays[scene.displayId] ?? WindowPeekOverlayPanel(frame: screen.frame)
        overlays[scene.displayId] = overlay
        overlay.display(surface, scene: scene, on: screen.frame)
    }

    private func stopStreams() {
        let stopping = streams
        let released = outputs
        streams = []
        outputs = []
        Task {
            for stream in stopping {
                try? await stream.stopCapture()
            }
            _ = released
        }
    }

    private func configuration(for display: SCDisplay) -> SCStreamConfiguration {
        let scale = NSScreen.screens
            .first { $0.displayNumber == Int(display.displayID) }?
            .backingScaleFactor ?? 1
        let configuration = SCStreamConfiguration()
        configuration.width = Int(CGFloat(display.width) * scale)
        configuration.height = Int(CGFloat(display.height) * scale)
        configuration.minimumFrameInterval = WindowPeekMetrics.frameInterval
        configuration.queueDepth = WindowPeekMetrics.queueDepth
        configuration.pixelFormat = kCVPixelFormatType_32BGRA
        configuration.showsCursor = false

        return configuration
    }

    private func report(_ outcome: String) {
        guard reported != outcome else { return }

        reported = outcome
        BarLog.bar.notice("peek \(outcome, privacy: .public)")
    }
}
