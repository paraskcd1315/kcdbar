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

/** Traces the bar's free edges, leaving out the one attached to the screen. */
package struct KbBarEdgeOutline: Shape {
    package let edge: BarEdge
    package let attachment: BarAttachment
    package let cornerRadius: CGFloat

    package func path(in rect: CGRect) -> Path {
        guard attachment == .edgeAttached else {
            return Path(roundedRect: rect, cornerRadius: cornerRadius)
        }

        let corners = traversal(in: rect)
        var path = Path()
        path.move(to: corners[0])
        path.addArc(tangent1End: corners[1], tangent2End: corners[2], radius: cornerRadius)
        path.addArc(tangent1End: corners[2], tangent2End: corners[3], radius: cornerRadius)
        path.addLine(to: corners[3])

        return path
    }

    private func traversal(in rect: CGRect) -> [CGPoint] {
        let topLeading = CGPoint(x: rect.minX, y: rect.minY)
        let topTrailing = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeading = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomTrailing = CGPoint(x: rect.maxX, y: rect.maxY)

        switch edge {
        case .bottom: return [bottomLeading, topLeading, topTrailing, bottomTrailing]
        case .top: return [topLeading, bottomLeading, bottomTrailing, topTrailing]
        case .leading: return [topLeading, topTrailing, bottomTrailing, bottomLeading]
        case .trailing: return [topTrailing, topLeading, bottomLeading, bottomTrailing]
        }
    }
}
