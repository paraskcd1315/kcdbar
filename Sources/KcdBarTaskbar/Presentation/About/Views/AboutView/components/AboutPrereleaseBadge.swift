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

/** Marks the build as an alpha. */
package struct AboutPrereleaseBadge: View {
    package init() {}

    package var body: some View {
        Text(LocalizedStringKey.catalogue("about", "badge", "alpha"))
            .font(AboutMetrics.badge)
            .foregroundStyle(.white)
            .padding(.horizontal, AboutMetrics.badgePaddingHorizontal)
            .padding(.vertical, AboutMetrics.badgePaddingVertical)
            .background(
                RoundedRectangle(cornerRadius: AboutMetrics.badgeCornerRadius, style: .continuous)
                    .fill(.orange)
            )
    }
}
