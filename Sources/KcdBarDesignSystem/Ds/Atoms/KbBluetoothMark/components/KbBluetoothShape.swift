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

/** The Bluetooth rune, which SF Symbols does not ship. */
package struct KbBluetoothShape: Shape {
    package func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: point(rect, 0.16, 0.30))
        path.addLine(to: point(rect, 0.84, 0.70))
        path.addLine(to: point(rect, 0.50, 0.98))
        path.addLine(to: point(rect, 0.50, 0.02))
        path.addLine(to: point(rect, 0.84, 0.30))
        path.addLine(to: point(rect, 0.16, 0.70))

        return path
    }

    private func point(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: rect.minX + rect.width * x, y: rect.minY + rect.height * y)
    }
}
