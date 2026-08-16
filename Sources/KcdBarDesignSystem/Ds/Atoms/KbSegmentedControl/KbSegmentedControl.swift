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
