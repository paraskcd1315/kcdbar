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

struct TaskbarPreviewFitTests {
    private let ceiling = CGSize(width: 168, height: 104)

    @Test func aWideWindowFillsTheWidthAndKeepsItsShape() {
        let size = TaskbarPreviewFit.size(of: CGSize(width: 1920, height: 1030), within: ceiling)

        #expect(size == CGSize(width: 168, height: 90))
    }

    @Test func aTallWindowFillsTheHeightAndKeepsItsShape() {
        let size = TaskbarPreviewFit.size(of: CGSize(width: 600, height: 900), within: ceiling)

        #expect(size == CGSize(width: 69, height: 104))
    }

    @Test func aWindowSmallerThanTheCeilingDrawsAtItsOwnSize() {
        let size = TaskbarPreviewFit.size(of: CGSize(width: 120, height: 80), within: ceiling)

        #expect(size == CGSize(width: 120, height: 80))
    }

    @Test func aWindowWithNoSizeTakesTheCeiling() {
        #expect(TaskbarPreviewFit.size(of: .zero, within: ceiling) == ceiling)
    }

    @Test func aThumbnailCarriesTheFittedSizeOfItsWindow() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(
            for: [TaskbarPreviewWindow(id: 10, size: CGSize(width: 1920, height: 1030))],
            previews: [:]
        )

        #expect(thumbnails.first?.size == CGSize(width: 168, height: 90))
    }

    @Test func aThumbnailCarriesItsWindowsDisplayAndFullScreenState() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(
            for: [TaskbarPreviewWindow(
                id: 10, size: CGSize(width: 800, height: 600), displayName: "Left", isFullScreen: true)],
            previews: [:]
        )

        #expect(thumbnails.first?.displayName == "Left")
        #expect(thumbnails.first?.isFullScreen == true)
        #expect(thumbnails.first?.hasCaption == true)
    }

    @Test func aThumbnailOnThisDisplayInAWindowWithNoTitleHasNoCaption() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(
            for: [TaskbarPreviewWindow(id: 10, size: CGSize(width: 800, height: 600))],
            previews: [:]
        )

        #expect(thumbnails.first?.hasCaption == false)
    }
}
