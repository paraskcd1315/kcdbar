import KcdBarDesignSystem
import SwiftUI

package struct StartMenuLetterGrid: View {
    package let keys: [String]
    package let available: Set<String>
    package let onSelect: (String) -> Void

    package var body: some View {
        LazyVGrid(columns: columns, spacing: KbSpacing.s3) {
            StartMenuLetterCell(
                key: StartMenuMetrics.topAnchorKey,
                glyph: StartMenuMetrics.recentGlyph,
                isAvailable: true,
                onSelect: { onSelect(StartMenuMetrics.topAnchorKey) }
            )
            ForEach(keys, id: \.self) { key in
                StartMenuLetterCell(
                    key: key,
                    isAvailable: available.contains(key),
                    onSelect: { onSelect(key) }
                )
            }
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.vertical, KbSpacing.s5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: KbSpacing.s3),
            count: StartMenuMetrics.letterGridColumns
        )
    }
}
