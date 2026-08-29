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

package struct KbWindowsMark: View {
    package let generation: KbWindowsGeneration
    package let size: CGFloat

    package init(generation: KbWindowsGeneration, size: CGFloat) {
        self.generation = generation
        self.size = size
    }

    package var body: some View {
        Group {
            switch generation {
            case .eleven: KbWindows11Shape().fill(KbGradients.mark)
            case .ten: KbWindows10Shape().fill(KbGradients.mark)
            }
        }
        .frame(width: size * KbWindowsMarkMetrics.widthRatio, height: size)
    }
}
