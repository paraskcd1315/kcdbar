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

package struct TaskbarEntryStack: View {
    package let side: CGFloat
    package let sheets: Int

    package var body: some View {
        ZStack {
            ForEach((0..<sheets).reversed(), id: \.self) { index in
                let sheet = index + 1
                RoundedRectangle(cornerRadius: TaskbarMetrics.stackCornerRadius)
                    .fill(KbColors.surfaceRaised.opacity(TaskbarMetrics.stackFillOpacity))
                    .overlay {
                        RoundedRectangle(cornerRadius: TaskbarMetrics.stackCornerRadius)
                            .strokeBorder(KbColors.onSurfaceMuted, lineWidth: TaskbarMetrics.separatorThickness)
                    }
                    .frame(width: sheetSide, height: sheetSide)
                    .offset(
                        x: TaskbarMetrics.stackStep * CGFloat(sheet),
                        y: -TaskbarMetrics.stackStep * CGFloat(sheet)
                    )
            }
        }
        .frame(width: side, height: side)
        .allowsHitTesting(false)
    }

    private var sheetSide: CGFloat {
        side - TaskbarMetrics.stackInset * 2
    }
}
