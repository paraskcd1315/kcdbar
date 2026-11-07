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
import KcdBarDesignSystem
import SwiftUI
import Testing

@testable import KcdBarTaskbar

@MainActor
struct TaskbarTooltipWidthTests {
    private let longTitle = "Diego Ceballos (Mensaje directo) - Unimedia Technology - Slack workspace"

    @Test func aLongTitleNeverWidensThePanelPastItsThumbnail() {
        let thumbnail = TaskbarPreviewThumbnail(id: 1, size: CGSize(width: 120, height: 80), image: nil)

        let width = fittedWidth(of: tooltip(thumbnails: [thumbnail]))

        #expect(width == thumbnail.size.width + KbSpacing.s5 * 2)
    }

    @Test func aTooltipWithoutThumbnailsStillSizesToItsText() {
        let width = fittedWidth(of: tooltip(thumbnails: []))

        #expect(width > KbSpacing.s5 * 2)
        #expect(width <= TaskbarMetrics.tooltipMaxWidth + KbSpacing.s5 * 2)
    }

    private func tooltip(thumbnails: [TaskbarPreviewThumbnail]) -> TaskbarTooltip {
        TaskbarTooltip(
            applicationName: "Slack",
            windowTitle: longTitle,
            thumbnails: thumbnails,
            icon: nil,
            onRaiseWindow: { _ in },
            onCloseWindow: { _ in }
        )
    }

    private func fittedWidth(of view: TaskbarTooltip) -> CGFloat {
        NSHostingView(rootView: view).fittingSize.width
    }
}
