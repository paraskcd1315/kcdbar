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

struct InactiveSpacePromotionTests {
    private let display = DisplayGeometry(
        id: 1, frame: CGRect(x: -1920, y: 0, width: 1920, height: 1080), isPrimary: false, name: "Left")

    private func window(_ id: CGWindowID, source: WindowRecordSource, size: CGSize = CGSize(width: 800, height: 600)) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: 5, cgWindowId: id, fallbackKey: "5:\(id)"),
            ownerPid: 5, ownerName: "Term", title: "Doc",
            bounds: CGRect(origin: CGPoint(x: -1920, y: 0), size: size),
            isMinimized: false, isFullScreen: false, isOnScreen: false, zOrder: Int.max, source: source)
    }

    @Test func onlyCoreGraphicsOnlyWindowsAreCandidates() {
        let ids = InactiveSpacePromotion.candidates(among: [
            window(10, source: .coreGraphicsOnly), window(11, source: .both), window(12, source: .coreGraphicsOnly),
        ])

        #expect(ids == [10, 12])
    }

    @Test func aStripIsNeverACandidate() {
        let ids = InactiveSpacePromotion.candidates(among: [
            window(10, source: .coreGraphicsOnly, size: CGSize(width: 1920, height: 68)),
            window(11, source: .coreGraphicsOnly, size: CGSize(width: 1920, height: 1080)),
        ])

        #expect(ids == [11])
    }

    @Test func aWindowOnAnInactiveSpaceBecomesAnEntry() {
        let promoted = InactiveSpacePromotion.promote(
            [window(10, source: .coreGraphicsOnly)], onInactiveSpaces: [10], displays: [display])

        #expect(promoted.first?.source == .inactiveSpace)
        #expect(WindowPresentationPolicy.isTaskbarEntry(promoted[0]))
    }

    @Test func aWindowFillingItsDisplayReadsAsFullScreen() {
        let promoted = InactiveSpacePromotion.promote(
            [window(10, source: .coreGraphicsOnly, size: CGSize(width: 1920, height: 1080))],
            onInactiveSpaces: [10], displays: [display])

        #expect(promoted.first?.isFullScreen == true)
    }

    @Test func aWindowSkyLightDidNotNameStaysCoreGraphicsOnly() {
        let promoted = InactiveSpacePromotion.promote(
            [window(10, source: .coreGraphicsOnly)], onInactiveSpaces: [], displays: [display])

        #expect(promoted.first?.source == .coreGraphicsOnly)
        #expect(!WindowPresentationPolicy.isTaskbarEntry(promoted[0]))
    }

    @Test func aConfirmedWindowIsLeftAlone() {
        let promoted = InactiveSpacePromotion.promote(
            [window(11, source: .both)], onInactiveSpaces: [11], displays: [display])

        #expect(promoted.first?.source == .both)
    }
}
