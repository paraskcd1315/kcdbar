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

/** A rounded panel, optionally carrying a caret on its lower edge that points at the item that opened it. */
package struct KbPopoverShape: Shape {
    package let arrowX: CGFloat?

    package init(arrowX: CGFloat?) {
        self.arrowX = arrowX
    }

    package func path(in rect: CGRect) -> Path {
        let radius = KbRadii.lg
        guard let arrowX else {
            return Path(roundedRect: rect, cornerRadius: radius)
        }
        let arrow = KbPopoverMetrics.arrowSize
        let body = CGRect(
            x: rect.minX,
            y: rect.minY,
            width: rect.width,
            height: rect.height - arrow.height
        )
        let lower = body.minX + radius + arrow.width
        let upper = body.maxX - radius - arrow.width
        let tip = min(max(arrowX, lower), upper)

        var path = Path(roundedRect: body, cornerRadius: radius)
        path.move(to: CGPoint(x: tip - arrow.width / 2, y: body.maxY))
        path.addLine(to: CGPoint(x: tip, y: rect.maxY))
        path.addLine(to: CGPoint(x: tip + arrow.width / 2, y: body.maxY))
        path.closeSubpath()

        return path
    }
}
