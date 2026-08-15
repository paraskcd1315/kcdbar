import SwiftUI

struct TrayMenuView: View {
    let title: String
    let entries: [MenuBarEntry]
    let onSelect: (MenuBarEntry) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(entries) { entry in
                    if entry.isSeparator {
                        Rectangle()
                            .fill(KbColors.separator)
                            .frame(height: TrayMetrics.separatorHeight)
                            .padding(.vertical, KbSpacing.s1)
                    } else {
                        TrayMenuRow(entry: entry) { onSelect(entry) }
                    }
                }
            }
            .padding(KbSpacing.s2)
        }
        .scrollBounceBehavior(.basedOnSize)
        .frame(width: TrayMetrics.menuWidth)
        .frame(maxHeight: TrayMetrics.menuMaxHeight)
        .fixedSize(horizontal: false, vertical: true)
        .glassEffect(.regular, in: .rect(cornerRadius: KbRadii.lg))
    }
}
