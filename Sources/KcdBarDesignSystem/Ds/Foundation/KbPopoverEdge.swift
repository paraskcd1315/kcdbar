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

/** The popover's rim, drawn outside the glass so the material does not blur it. */
package struct KbPopoverEdge: View {
    package let arrowX: CGFloat?

    package init(arrowX: CGFloat?) {
        self.arrowX = arrowX
    }

    package var body: some View {
        ZStack {
            outline
                .stroke(KbColors.glassEdgeBright, lineWidth: KbEdgeMetrics.width)
                .blendMode(.plusLighter)
            outline
                .stroke(KbColors.glassEdgeShade, lineWidth: KbEdgeMetrics.width)
                .blendMode(.plusDarker)
        }
        .allowsHitTesting(false)
    }

    private var outline: KbPopoverShape {
        KbPopoverShape(arrowX: arrowX)
    }
}
