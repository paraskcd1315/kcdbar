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

package struct WifiNote: View {
    package let titleKey: LocalizedStringKey

    package var body: some View {
        Text(titleKey)
            .font(KbTypography.tileStatus)
            .foregroundStyle(KbColors.onSurfaceMuted)
            .padding(.horizontal, KbSpacing.s4)
            .padding(.vertical, KbSpacing.s2)
    }
}
