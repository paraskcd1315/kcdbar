import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTooltipLayer: View {
    package let hover: TaskbarHoverState
    package let edge: BarEdge

    @State private var size: CGSize = .zero

    package var body: some View {
        GeometryReader { proxy in
            if let entry = hover.entry {
                TaskbarTooltip(applicationName: entry.applicationName, windowTitle: entry.title)
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
                    .transition(.opacity.combined(with: .scale(scale: TaskbarMetrics.tooltipAppearScale)))
            }
        }
        .allowsHitTesting(false)
        .animation(KbMotion.quick, value: hover.entry)
    }

    private var measured: CGSize {
        guard size.width > 0, size.height > 0 else {
            return CGSize(width: TaskbarMetrics.tooltipMaxWidth, height: TaskbarMetrics.tooltipAllowance)
        }
        return size
    }
}
