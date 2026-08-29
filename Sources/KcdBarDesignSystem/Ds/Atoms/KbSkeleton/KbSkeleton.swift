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

/** A shimmering placeholder standing in for content that has not arrived. */
package struct KbSkeleton: View {
    package var width: CGFloat?
    package var height: CGFloat = KbSkeletonMetrics.lineHeight
    package var shape: AnyShape = AnyShape(Capsule())

    @State private var isShimmering = false

    package init(
        width: CGFloat? = nil,
        height: CGFloat = KbSkeletonMetrics.lineHeight,
        shape: AnyShape = AnyShape(Capsule())
    ) {
        self.width = width
        self.height = height
        self.shape = shape
    }

    package var body: some View {
        shape
            .fill(KbColors.onSurface.opacity(KbSkeletonMetrics.baseOpacity))
            .frame(width: width, height: height)
            .frame(maxWidth: width == nil ? .infinity : nil, alignment: .leading)
            .opacity(isShimmering ? KbSkeletonMetrics.shimmerOpacity : 1)
            .animation(
                .easeInOut(duration: KbSkeletonMetrics.shimmerDuration).repeatForever(),
                value: isShimmering
            )
            .onAppear { isShimmering = true }
    }
}
