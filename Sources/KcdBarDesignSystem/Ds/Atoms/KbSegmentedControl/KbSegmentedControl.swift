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

/** A row of exclusive choices, each drawn from the caller's own values. */
package struct KbSegmentedControl<Value: Hashable>: View {
    package let segments: [KbSegment<Value>]
    package let selection: Value
    package let shape: AnyShape
    package let onSelect: (Value) -> Void

    package init(
        segments: [KbSegment<Value>],
        selection: Value,
        shape: AnyShape = AnyShape(Capsule()),
        onSelect: @escaping (Value) -> Void
    ) {
        self.segments = segments
        self.selection = selection
        self.shape = shape
        self.onSelect = onSelect
    }

    package var body: some View {
        HStack(spacing: 0) {
            ForEach(segments) { segment in
                KbSegmentButton(
                    segment: segment,
                    isSelected: segment.value == selection,
                    shape: shape,
                    onSelect: { onSelect(segment.value) }
                )
            }
        }
        .frame(height: KbSegmentedControlMetrics.height)
        .glassEffect(.regular.interactive(), in: shape)
        .overlay(shape.stroke(KbColors.separator, lineWidth: KbEdgeMetrics.width))
    }
}
