import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTooltipLayer: View {
    package let hover: TaskbarHoverState
    package let previews: TaskbarPreviewState
    package let edge: BarEdge

    @State private var size: CGSize = .zero

    package var body: some View {
        GeometryReader { proxy in
            if let entry = hover.entry {
                TaskbarTooltip(
                    applicationName: entry.applicationName,
                    windowTitle: entry.title,
                    thumbnails: TaskbarPreviewThumbnail.thumbnails(
                        for: entry.previewWindowIds,
                        previews: previews.previews
                    ),
                    icon: entry.icon
                )
                    .onGeometryChange(for: CGSize.self) { $0.size } action: { size = $0 }
                    .position(
                        x: TaskbarTooltipPlacement.x(
                            over: hover.frame,
                            tooltip: measured,
                            panel: proxy.size,
                            edge: edge
                        ),
                        y: TaskbarTooltipPlacement.y(
                            over: hover.frame,
                            tooltip: measured,
                            panel: proxy.size,
                            edge: edge
                        )
                    )
                    .id(entry.id)
                    .transition(
                        .move(edge: TaskbarTooltipPlacement.arrival(for: edge)).combined(with: .opacity)
                    )
            }
        }
        .allowsHitTesting(false)
        .animation(KbMotion.quick, value: hover.entry?.id)
        .task(id: hover.entry?.id) {
            guard let entry = hover.entry else {
                previews.clear()
                return
            }
            await previews.load(entry.previewWindowIds)
        }
    }

    private var measured: CGSize {
        guard size.width > 0, size.height > 0 else {
            return CGSize(width: TaskbarMetrics.tooltipMaxWidth, height: TaskbarMetrics.tooltipAllowance)
        }
        return size
    }
}
