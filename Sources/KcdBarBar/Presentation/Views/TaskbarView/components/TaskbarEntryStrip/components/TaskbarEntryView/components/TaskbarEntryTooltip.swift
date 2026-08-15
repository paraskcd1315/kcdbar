import SwiftUI

package struct TaskbarEntryTooltip: View {
    package let entry: TaskbarEntryModel
    package let edge: BarEdge

    package var body: some View {
        TaskbarTooltip(applicationName: entry.applicationName, windowTitle: entry.title)
            .offset(TaskbarEntryStyle.tooltipOffset(edge: edge))
            .transition(.opacity.combined(with: .scale(scale: TaskbarMetrics.tooltipAppearScale)))
    }
}
