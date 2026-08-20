import KcdBarDesignSystem
import SwiftUI

package enum TaskbarEntryStyle {
    package static func isOpenHere(_ entry: TaskbarEntryModel) -> Bool {
        entry.instancesOnThisDisplay > 0
    }

    package static func shape(isOpenHere: Bool, cornerRadius: CGFloat) -> AnyShape {
        guard isOpenHere else { return AnyShape(RoundedRectangle(cornerRadius: cornerRadius)) }

        return AnyShape(
            UnevenRoundedRectangle(topLeadingRadius: cornerRadius, topTrailingRadius: cornerRadius)
        )
    }

    package static func fill(sizing: BarEntrySizing, isFrontmost: Bool, isHovered: Bool) -> Color {
        guard sizing != .magnifying else { return .clear }

        if isFrontmost {
            return KbColors.onSurface.opacity(TaskbarMetrics.focusedFillOpacity)
        }
        return isHovered ? KbColors.onSurface.opacity(TaskbarMetrics.hoverFillOpacity) : .clear
    }

    package static func magnification(sizing: BarEntrySizing, isHovered: Bool) -> CGFloat {
        guard isHovered, sizing == .magnifying else { return 1 }

        return TaskbarMetrics.magnificationScale
    }

    package static func magnificationAnchor(edge: BarEdge) -> UnitPoint {
        switch edge {
        case .bottom: .bottom
        case .top: .top
        case .leading: .leading
        case .trailing: .trailing
        }
    }

    package static func showsTitle(content: BarEntryContent, isLauncher: Bool) -> Bool {
        content != .iconOnly && !isLauncher
    }
}
