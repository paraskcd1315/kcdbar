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
import Foundation

@MainActor
package final class WindowOverlapEnforcer {
    private let control: any WindowControlPort
    private var lastCorrection: [String: Date] = [:]
    private var lastPreset: BarPreset?

    package init(control: any WindowControlPort) {
        self.control = control
    }

    package func enforce(preset: BarPreset, windows: [ManagedWindow], displays: [DisplayGeometry], now: Date) {
        if lastPreset != preset {
            lastPreset = preset
            lastCorrection = [:]
        }
        guard preset.overlap == .pushDisplayFillingWindows else { return }

        for window in windows {
            guard window.isOnScreen, WindowSpacePolicy.isOnActiveSpace(window) else { continue }
            guard correction(for: window, preset: preset, displays: displays) != nil else { continue }
            let key = WindowEntryIdentifier.text(for: window.identity)
            guard shouldCorrect(key: key, now: now),
                  let actual = control.frame(of: window),
                  let corrected = correction(for: window.placed(at: actual), preset: preset, displays: displays)
            else {
                continue
            }
            lastCorrection[key] = now
            _ = control.setFrame(corrected, on: window)
        }
    }

    private func correction(for window: ManagedWindow, preset: BarPreset, displays: [DisplayGeometry]) -> CGRect? {
        guard let displayId = WindowDisplayResolver.displayId(for: window, in: displays),
              let display = displays.first(where: { $0.id == displayId })
        else {
            return nil
        }
        return WindowOverlapPolicy.correctedFrame(
            for: window,
            barFrame: BarFrameCalculator.frame(for: preset, on: display),
            display: display
        )
    }

    private func shouldCorrect(key: String, now: Date) -> Bool {
        guard let previous = lastCorrection[key] else { return true }
        return now.timeIntervalSince(previous) >= WindowOverlapMetrics.reapplyInterval
    }
}
