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

package struct TaskbarEntryBadgeCount: View {
    package let count: Int

    package var body: some View {
        Text(verbatim: "\(count)")
            .font(.system(size: TaskbarMetrics.fullScreenCountFont, weight: .bold))
            .foregroundStyle(KbColors.onBrand)
            .frame(width: TaskbarMetrics.fullScreenCountSide, height: TaskbarMetrics.fullScreenCountSide)
            .background(KbColors.brand, in: .circle)
    }
}
