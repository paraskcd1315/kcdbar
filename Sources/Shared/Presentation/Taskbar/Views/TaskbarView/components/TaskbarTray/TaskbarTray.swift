import SwiftUI

struct TaskbarTray: View {
    let items: [TrayItemModel]
    let isVertical: Bool
    let onPress: (TrayItemModel) -> Void

    var body: some View {
        KbAxisStack(isVertical: isVertical, spacing: KbSpacing.s1) {
            ForEach(items) { item in
                TaskbarTrayIcon(item: item) { onPress(item) }
                    .transition(.opacity.combined(with: .scale(scale: TaskbarMetrics.insertionScale)))
            }
        }
        .animation(KbMotion.standard, value: items)
    }
}
