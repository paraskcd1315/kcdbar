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
import Testing

@testable import KcdBarTaskbar

@MainActor
struct WindowOverlapEnforcerTests {
    private let display = DisplayGeometry(
        id: 1,
        frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
        isPrimary: true
    )

    private func zoomedWindow(isOnScreen: Bool = true) -> ManagedWindow {
        let bounds = CGRect(x: 0, y: 0, width: 1920, height: 1080)
        let cg = WindowFixtures.cgRecord(windowId: 1, pid: 1, title: "W", bounds: bounds, isOnScreen: isOnScreen)
        let ax = WindowFixtures.axRecord(pid: 1, cgWindowId: 1, title: "W", bounds: bounds)

        return WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])[0]
    }

    @Test func aWindowCoreGraphicsReportsOffScreenIsLeftAlone() {
        let control = RecordingWindowControl()
        let enforcer = WindowOverlapEnforcer(control: control)

        enforcer.enforce(
            preset: BarPresetCatalogue.windows11,
            windows: [zoomedWindow(isOnScreen: false)],
            displays: [display],
            now: Date(timeIntervalSince1970: 0)
        )

        #expect(control.framed.isEmpty)
    }

    @Test func theSamePresetTwiceInsideTheIntervalCorrectsOnce() {
        let control = RecordingWindowControl()
        let enforcer = WindowOverlapEnforcer(control: control)
        let now = Date(timeIntervalSince1970: 0)
        let windows = [zoomedWindow()]

        enforcer.enforce(preset: BarPresetCatalogue.windows11, windows: windows, displays: [display], now: now)
        enforcer.enforce(
            preset: BarPresetCatalogue.windows11,
            windows: windows,
            displays: [display],
            now: now.addingTimeInterval(0.1)
        )

        #expect(control.framed.count == 1)
    }

    @Test func aChangedPresetCorrectsAtOnceRatherThanWaitingOutTheInterval() {
        let control = RecordingWindowControl()
        let enforcer = WindowOverlapEnforcer(control: control)
        let now = Date(timeIntervalSince1970: 0)
        let windows = [zoomedWindow()]

        enforcer.enforce(preset: BarPresetCatalogue.windows11, windows: windows, displays: [display], now: now)

        var thicker = BarPresetCatalogue.windows11
        thicker.thickness += 20
        enforcer.enforce(
            preset: thicker,
            windows: windows,
            displays: [display],
            now: now.addingTimeInterval(0.1)
        )

        #expect(control.framed.count == 2)
        #expect(control.framed.last?.0.minY == thicker.thickness)
    }

    private func animatedWindow() -> ManagedWindow {
        let thumbnail = CGRect(x: 100, y: 20, width: 800, height: 500)
        let cg = WindowFixtures.cgRecord(windowId: 7, pid: 7, title: "T", bounds: thumbnail)
        let ax = WindowFixtures.axRecord(pid: 7, cgWindowId: 7, title: "T", bounds: thumbnail)

        return WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])[0]
    }

    @Test func aMissionControlThumbnailOverTheBarLeavesAWindowClearOfItAlone() {
        let control = RecordingWindowControl()
        let window = animatedWindow()
        control.actualFrames[window.identity] = CGRect(x: 0, y: 200, width: 1920, height: 880)
        let enforcer = WindowOverlapEnforcer(control: control)

        enforcer.enforce(
            preset: BarPresetCatalogue.windows11,
            windows: [window],
            displays: [display],
            now: Date(timeIntervalSince1970: 0)
        )

        #expect(control.framed.isEmpty)
    }

    @Test func aWindowReallyOverTheBarIsFittedFromItsOwnFrameNotTheThumbnail() {
        let control = RecordingWindowControl()
        let window = animatedWindow()
        control.actualFrames[window.identity] = CGRect(x: 300, y: 10, width: 600, height: 400)
        let enforcer = WindowOverlapEnforcer(control: control)
        let preset = BarPresetCatalogue.windows11

        enforcer.enforce(preset: preset, windows: [window], displays: [display], now: Date(timeIntervalSince1970: 0))

        #expect(control.framed.map(\.0) == [CGRect(x: 300, y: preset.thickness, width: 600, height: 400)])
    }

    @Test func aWindowWhoseOwnFrameCannotBeReadIsLeftAlone() {
        let control = RecordingWindowControl()
        control.framesReadable = false
        let enforcer = WindowOverlapEnforcer(control: control)

        enforcer.enforce(
            preset: BarPresetCatalogue.windows11,
            windows: [zoomedWindow()],
            displays: [display],
            now: Date(timeIntervalSince1970: 0)
        )

        #expect(control.framed.isEmpty)
    }
}
