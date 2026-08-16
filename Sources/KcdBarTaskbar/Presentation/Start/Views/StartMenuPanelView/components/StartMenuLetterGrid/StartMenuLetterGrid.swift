import KcdBarDesignSystem
import SwiftUI

package struct StartMenuLetterGrid: View {
    package let keys: [String]
    package let available: Set<String>
    package let onSelect: (String) -> Void
    package let onDismiss: () -> Void

    package var body: some View {
        ZStack {
            Rectangle()
                .fill(KbColors.scrim)
                .kbTappable(in: Rectangle(), perform: onDismiss)
            LazyVGrid(columns: columns, spacing: KbSpacing.s3) {
                ForEach(keys, id: \.self) { key in
                    StartMenuLetterCell(
                        key: key,
                        isAvailable: available.contains(key),
                        onSelect: {
                            onSelect(key)
                            onDismiss()
                        }
                    )
                }
            }
            .padding(KbSpacing.s5)
            .glassEffect(.regular.interactive(), in: shape)
            .overlay(shape.stroke(KbColors.separator, lineWidth: KbEdgeMetrics.width))
            .padding(KbSpacing.s6)
        }
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: KbSpacing.s3),
            count: StartMenuMetrics.letterGridColumns
        )
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.lg, style: .continuous)
    }
}
