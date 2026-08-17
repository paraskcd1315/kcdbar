import SwiftUI

package struct KbSegmentButton<Value: Hashable>: View {
    package let segment: KbSegment<Value>
    package let isSelected: Bool
    package let shape: AnyShape
    package let onSelect: () -> Void

    @State private var isHovered = false

    package init(
        segment: KbSegment<Value>,
        isSelected: Bool,
        shape: AnyShape,
        onSelect: @escaping () -> Void
    ) {
        self.segment = segment
        self.isSelected = isSelected
        self.shape = shape
        self.onSelect = onSelect
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s2) {
            if let glyph = segment.glyph {
                Image(systemName: glyph)
                    .font(.system(size: KbSegmentedControlMetrics.glyphSize, weight: .semibold))
            }
            if let titleKey = segment.titleKey {
                Text(titleKey).font(KbTypography.entryTitle)
            }
        }
        .foregroundStyle(isSelected ? KbColors.onSurface : KbColors.onSurfaceMuted)
        .padding(.horizontal, KbSpacing.s4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(fill, in: shape)
        .kbTappable(in: shape, perform: onSelect)
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isSelected)
        .animation(KbMotion.quick, value: isHovered)
    }

    private var fill: Color {
        guard !isSelected else {
            return KbColors.onSurface.opacity(KbSegmentedControlMetrics.selectedFillOpacity)
        }

        return isHovered
            ? KbColors.onSurface.opacity(KbSegmentedControlMetrics.hoverFillOpacity)
            : .clear
    }
}
