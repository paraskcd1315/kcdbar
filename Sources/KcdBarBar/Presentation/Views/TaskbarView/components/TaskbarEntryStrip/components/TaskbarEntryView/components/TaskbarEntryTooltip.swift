import SwiftUI

struct TaskbarEntryTooltip: View {
    let entry: TaskbarEntryModel
    let edge: BarEdge

    var body: some View {
        TaskbarTooltip(applicationName: entry.applicationName, windowTitle: entry.title)
            .offset(TaskbarEntryStyle.tooltipOffset(edge: edge))
            .transition(.opacity.combined(with: .scale(scale: TaskbarMetrics.tooltipAppearScale)))
    }
}
