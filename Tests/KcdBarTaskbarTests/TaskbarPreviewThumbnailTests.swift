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
import SwiftUI
import Testing

@testable import KcdBarTaskbar

struct TaskbarPreviewThumbnailTests {
    private let captured = WindowPreview(image: Image(systemName: "rectangle"), pixelSize: CGSize(width: 320, height: 200))

    private func windows(_ ids: [CGWindowID]) -> [TaskbarPreviewWindow] {
        ids.map { TaskbarPreviewWindow(id: $0, size: CGSize(width: 1200, height: 800)) }
    }

    @Test func aThumbnailKeepsTheWindowOrderTheEntryGaveIt() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(for: windows([12, 10, 11]), previews: [:])

        #expect(thumbnails.map(\.id) == [12, 10, 11])
    }

    @Test func aWindowWithNoCaptureStillGetsATile() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(for: windows([10, 11]), previews: [10: captured])

        #expect(thumbnails.count == 2)
        #expect(thumbnails[1].image == nil)
    }

    @Test func aCapturedTileTakesTheCapturesShapeNotTheWindowsBounds() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(for: windows([10]), previews: [10: captured])

        #expect(thumbnails.first?.size == CGSize(width: 166, height: 104))
    }

    @Test func anUncapturedTileTakesTheWindowsBounds() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(for: windows([10]), previews: [:])

        #expect(thumbnails.first?.size == CGSize(width: 156, height: 104))
    }

    @Test func aGroupedEntryDrawsNoMoreTilesThanItMayShow() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(
            for: windows([10, 11, 12, 13, 14, 15]),
            previews: [:]
        )

        #expect(thumbnails.count == TaskbarPreviewMetrics.maximumThumbnails)
    }

    @Test func anEntryWithNoWindowDrawsNoTiles() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(for: [], previews: [10: captured])

        #expect(thumbnails.isEmpty)
    }

    @Test func aTitledTileHasACaptionAndABareOneDoesNot() {
        let titled = TaskbarPreviewThumbnail.thumbnails(
            for: [TaskbarPreviewWindow(id: 10, size: CGSize(width: 800, height: 600), title: "Doc", profile: "Paras")],
            previews: [:]
        )
        let bare = TaskbarPreviewThumbnail.thumbnails(
            for: [TaskbarPreviewWindow(id: 11, size: CGSize(width: 800, height: 600), title: "")],
            previews: [:]
        )

        #expect(titled.first?.hasCaption == true)
        #expect(titled.first?.profile == "Paras")
        #expect(bare.first?.hasCaption == false)
    }
}
