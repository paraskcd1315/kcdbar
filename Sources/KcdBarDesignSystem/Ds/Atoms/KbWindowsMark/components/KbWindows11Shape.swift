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

import SwiftUI

package struct KbWindows11Shape: Shape {
    package init() {}

    package func path(in rect: CGRect) -> Path {
        let side = min(rect.width, rect.height)
        let pane = side * KbWindowsMarkMetrics.paneRatio
        let gap = side * KbWindowsMarkMetrics.gapRatio
        let radius = pane * KbWindowsMarkMetrics.paneRadiusRatio
        let origin = CGPoint(
            x: rect.midX - (pane + gap / 2),
            y: rect.midY - (pane + gap / 2)
        )

        var path = Path()
        for column in 0..<2 {
            for row in 0..<2 {
                let frame = CGRect(
                    x: origin.x + CGFloat(column) * (pane + gap),
                    y: origin.y + CGFloat(row) * (pane + gap),
                    width: pane,
                    height: pane
                )
                path.addRoundedRect(in: frame, cornerSize: CGSize(width: radius, height: radius))
            }
        }
        return path
    }
}
