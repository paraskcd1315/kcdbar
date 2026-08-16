import KcdBarDesignSystem
import SwiftUI

package struct StartMenuControls: View {
    package let grouping: StartMenuGrouping
    package let layout: StartMenuLayout
    package let showsIndexButton: Bool
    package let indexKey: String
    package let onGrouping: (StartMenuGrouping) -> Void
    package let onLayout: (StartMenuLayout) -> Void
    package let onIndex: () -> Void

    package var body: some View {
        HStack(spacing: KbSpacing.s4) {
            KbSegmentedControl(
                segments: StartMenuGrouping.allCases.map {
                    KbSegment(value: $0, titleKey: LocalizedStringKey($0.titleKey))
                },
                selection: grouping,
                onSelect: onGrouping
            )
            StartMenuIndexButton(
                isShowing: showsIndexButton,
                key: indexKey,
                onIndex: onIndex
            )
            KbSegmentedControl(
                segments: StartMenuLayout.allCases.map { KbSegment(value: $0, glyph: $0.glyph) },
                selection: layout,
                onSelect: onLayout
            )
            .fixedSize(horizontal: true, vertical: false)
        }
        .animation(KbMotion.standard, value: grouping)
        .animation(KbMotion.standard, value: layout)
        .animation(KbMotion.standard, value: showsIndexButton)
    }
}
