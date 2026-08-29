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

package enum TaskbarTooltipPlacement {
    package static func x(over item: CGRect, tooltip: CGSize, panel: CGSize, edge: BarEdge) -> CGFloat {
        guard !edge.isVertical else {
            return edge == .leading
                ? item.maxX + TaskbarMetrics.tooltipGap + tooltip.width / 2
                : item.minX - TaskbarMetrics.tooltipGap - tooltip.width / 2
        }
        return clamped(item.midX, half: tooltip.width / 2, limit: panel.width)
    }

    package static func y(over item: CGRect, tooltip: CGSize, panel: CGSize, edge: BarEdge) -> CGFloat {
        guard edge.isVertical else {
            return edge == .top
                ? item.maxY + TaskbarMetrics.tooltipGap + tooltip.height / 2
                : item.minY - TaskbarMetrics.tooltipGap - tooltip.height / 2
        }
        return clamped(item.midY, half: tooltip.height / 2, limit: panel.height)
    }

    package static func arrival(for edge: BarEdge) -> Edge {
        switch edge {
        case .bottom: .bottom
        case .top: .top
        case .leading: .leading
        case .trailing: .trailing
        }
    }

    private static func clamped(_ centre: CGFloat, half: CGFloat, limit: CGFloat) -> CGFloat {
        guard limit > half * 2 else { return limit / 2 }

        return min(max(centre, half + TaskbarMetrics.tooltipEdgeInset), limit - half - TaskbarMetrics.tooltipEdgeInset)
    }
}
