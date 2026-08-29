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

import KcdBarDesignSystem
import SwiftUI

package enum TaskbarEntryStyle {
    package static func isOpenHere(_ entry: TaskbarEntryModel) -> Bool {
        entry.instancesOnThisDisplay > 0
    }

    package static func shape(isOpenHere: Bool, cornerRadius: CGFloat) -> AnyShape {
        guard isOpenHere else { return AnyShape(RoundedRectangle(cornerRadius: cornerRadius)) }

        return AnyShape(
            UnevenRoundedRectangle(topLeadingRadius: cornerRadius, topTrailingRadius: cornerRadius)
        )
    }

    package static func fill(sizing: BarEntrySizing, isFrontmost: Bool, isHovered: Bool) -> Color {
        guard sizing != .magnifying else { return .clear }

        if isFrontmost {
            return KbColors.onSurface.opacity(TaskbarMetrics.focusedFillOpacity)
        }
        return isHovered ? KbColors.onSurface.opacity(TaskbarMetrics.hoverFillOpacity) : .clear
    }

    package static func magnification(sizing: BarEntrySizing, isHovered: Bool) -> CGFloat {
        guard isHovered, sizing == .magnifying else { return 1 }

        return TaskbarMetrics.magnificationScale
    }

    package static func magnificationAnchor(edge: BarEdge) -> UnitPoint {
        switch edge {
        case .bottom: .bottom
        case .top: .top
        case .leading: .leading
        case .trailing: .trailing
        }
    }

    package static func stackSheets(_ entry: TaskbarEntryModel, grouping: BarGrouping) -> Int {
        guard grouping == .perApplication else { return 0 }

        return min(max(entry.instanceCount - 1, 0), TaskbarMetrics.stackMaxSheets)
    }

    package static func showsTitle(content: BarEntryContent, isLauncher: Bool) -> Bool {
        content != .iconOnly && !isLauncher
    }
}
