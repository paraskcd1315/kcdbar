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
import Testing

@testable import KcdBarTaskbar

struct BarAutoHideTests {
    private let displays = [
        DisplayGeometry(id: 1, frame: CGRect(x: 0, y: 0, width: 1920, height: 1080), isPrimary: true)
    ]

    private func window(_ bounds: CGRect, order: Int = 0) -> ManagedWindow {
        let cg = WindowFixtures.cgRecord(windowId: 1, pid: 1, title: "W", bounds: bounds, zOrder: order)
        let ax = WindowFixtures.axRecord(pid: 1, cgWindowId: 1, title: "W", bounds: bounds)

        return WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])[0]
    }

    private func preset(_ policy: BarAutoHidePolicy) -> BarPreset {
        var preset = BarPresetCatalogue.windows11
        preset.autoHide = policy

        return preset
    }

    @Test func neverKeepsTheBarUpWithAWindowOverIt() {
        let covering = [window(CGRect(x: 0, y: 0, width: 1920, height: 1080))]

        #expect(
            !BarVisibilityPolicy.isHidden(
                preset: preset(.never),
                onDisplay: 1,
                windows: covering,
                displays: displays
            )
        )
    }

    @Test func alwaysHidesTheBarWithNothingOnScreenAtAll() {
        #expect(
            BarVisibilityPolicy.isHidden(preset: preset(.always), onDisplay: 1, windows: [], displays: displays)
        )
    }

    @Test func aWindowOnAnotherSpaceNeverCountsAsUnderneath() {
        let elsewhere = [window(CGRect(x: 0, y: 0, width: 1920, height: 1080), order: Int.max)]

        #expect(
            !BarVisibilityPolicy.isHidden(
                preset: preset(.whenOverlapped),
                onDisplay: 1,
                windows: elsewhere,
                displays: displays
            )
        )
    }

    @Test func whenOverlappedHidesOnlyWhileAWindowCoversTheBarsStrip() {
        let bar = BarFrameCalculator.frame(for: preset(.whenOverlapped), on: displays[0])
        let over = [window(CGRect(x: 0, y: 0, width: 1920, height: 1080))]
        let clear = [window(CGRect(x: 0, y: bar.maxY + 1, width: 1920, height: 400))]

        #expect(
            BarVisibilityPolicy.isHidden(
                preset: preset(.whenOverlapped),
                onDisplay: 1,
                windows: over,
                displays: displays
            )
        )
        #expect(
            !BarVisibilityPolicy.isHidden(
                preset: preset(.whenOverlapped),
                onDisplay: 1,
                windows: clear,
                displays: displays
            )
        )
    }
}
