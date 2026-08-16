import KcdBarDesignSystem
import SwiftUI

package struct StartMenuLetterGrid: View {
    package let keys: [String]
    package let available: Set<String>
    package let recents: [InstalledApplication]
    package let icons: any ApplicationIconPort
    package let onSelect: (String) -> Void
    package let onLaunch: (String) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s5) {
            StartMenuLetterRecents(
                applications: recents,
                icons: icons,
                onLaunch: onLaunch
            )
            LazyVGrid(columns: columns, spacing: KbSpacing.s3) {
                ForEach(keys, id: \.self) { key in
                    StartMenuLetterCell(
                        key: key,
                        isAvailable: available.contains(key),
                        onSelect: { onSelect(key) }
                    )
                }
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
