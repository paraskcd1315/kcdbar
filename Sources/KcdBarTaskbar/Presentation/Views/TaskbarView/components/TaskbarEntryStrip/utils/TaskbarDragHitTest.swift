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

/** Which entry slot a dragged pointer is over. */
package enum TaskbarDragHitTest {
    package static func key(at pointer: CGPoint, in slots: [String: CGRect], dragging: String?) -> String? {
        let hit = slots
            .filter { $0.key != dragging && $0.value.contains(pointer) }
            .min { distance(from: pointer, to: $0.value) < distance(from: pointer, to: $1.value) }

        return hit?.key
    }

    private static func distance(from pointer: CGPoint, to frame: CGRect) -> CGFloat {
        let dx = pointer.x - frame.midX
        let dy = pointer.y - frame.midY

        return dx * dx + dy * dy
    }
}
