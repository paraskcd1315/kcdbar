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

package struct KbBarSurface<Content: View>: View {
    package let material: BarMaterial
    package let edge: BarEdge
    package let attachment: BarAttachment
    package let cornerRadius: CGFloat
    @ViewBuilder package let content: () -> Content

    package var body: some View {
        GlassEffectContainer {
            KbBarFill(
                material: material,
                shape: KbBarShape.shape(edge: edge, attachment: attachment, cornerRadius: cornerRadius),
                content: content
            )
        }
        .overlay {
            KbBarEdge(edge: edge, attachment: attachment, cornerRadius: cornerRadius)
        }
    }
}
