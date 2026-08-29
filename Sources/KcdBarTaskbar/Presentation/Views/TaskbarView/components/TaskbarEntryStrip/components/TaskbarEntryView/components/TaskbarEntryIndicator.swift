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

package struct TaskbarEntryIndicator: View {
    package let entry: TaskbarEntryModel

    package var body: some View {
        if TaskbarEntryStyle.isOpenHere(entry) {
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: TaskbarMetrics.openBorderHeight)
                    .fill(entry.isFrontmost ? KbColors.activeIndicator : KbColors.onSurfaceMuted)
                    .frame(
                        width: entry.isFrontmost
                            ? proxy.size.width
                            : proxy.size.width * TaskbarMetrics.inactiveBorderFraction,
                        height: entry.isFrontmost
                            ? TaskbarMetrics.focusedBorderHeight
                            : TaskbarMetrics.openBorderHeight
                    )
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottom)
            }
            .frame(height: TaskbarMetrics.focusedBorderHeight)
            .animation(KbMotion.quick, value: entry.isFrontmost)
        } else if entry.instanceCount > 0 || entry.isRunning {
            TaskbarInstanceDots(
                count: entry.instanceCount,
                isRunning: entry.isRunning,
                isFrontmost: entry.isFrontmost
            )
            .padding(.bottom, TaskbarMetrics.instanceDotInset)
        }
    }
}
