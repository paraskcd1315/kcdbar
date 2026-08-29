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

package struct KbBarFill<Content: View>: View {
    package let material: BarMaterial
    package let shape: AnyShape
    @ViewBuilder package let content: () -> Content

    package var body: some View {
        switch material {
        case .liquidGlass:
            content().glassEffect(.regular.interactive(), in: shape)
        case .vibrancy:
            content().background(KbVibrancyBackdrop().clipShape(shape))
        case .solid:
            content().background(KbColors.surface.clipShape(shape))
        }
    }
}
