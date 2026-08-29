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

/** Stacks its content along the given axis, keeping view identity when the axis changes. */
package struct KbAxisStack<Content: View>: View {
    package let isVertical: Bool
    package let spacing: CGFloat
    @ViewBuilder package let content: () -> Content

    package init(
        isVertical: Bool,
        spacing: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isVertical = isVertical
        self.spacing = spacing
        self.content = content
    }

    package var body: some View {
        layout {
            content()
        }
    }

    private var layout: AnyLayout {
        isVertical
            ? AnyLayout(VStackLayout(spacing: spacing))
            : AnyLayout(HStackLayout(spacing: spacing))
    }
}
