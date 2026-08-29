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

package struct ControlCentreAccordion<Content: View>: View {
    package let titleKey: LocalizedStringKey
    @ViewBuilder package let content: Content

    @State private var isExpanded = false

    package init(titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.titleKey = titleKey
        self.content = content()
    }

    package var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ControlCentreAccordionHeader(titleKey: titleKey, isExpanded: isExpanded) {
                withAnimation(KbMotion.standard) { isExpanded.toggle() }
            }
            if isExpanded {
                content
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipped()
    }
}
