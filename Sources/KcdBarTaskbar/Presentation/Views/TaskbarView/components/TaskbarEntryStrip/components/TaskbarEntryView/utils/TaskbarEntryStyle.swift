import KcdBarDesignSystem
import SwiftUI

package enum TaskbarEntryStyle {
    package static func isOpenHere(_ entry: TaskbarEntryModel) -> Bool {
        entry.instancesOnThisDisplay > 0
    }

    package static func shape(isOpenHere: Bool) -> AnyShape {
        guard isOpenHere else { return AnyShape(RoundedRectangle(cornerRadius: KbRadii.md)) }

        return AnyShape(
            UnevenRoundedRectangle(topLeadingRadius: KbRadii.md, topTrailingRadius: KbRadii.md)
        )
    }

    package static func glass(isFrontmost: Bool, isHovered: Bool) -> Glass {
        if isFrontmost {
            return .regular.tint(KbColors.focusedFill).interactive()
        }
        return isHovered ? .regular.interactive() : .identity
    }

    package static func showsTitle(content: BarEntryContent, isLauncher: Bool) -> Bool {
        content != .iconOnly && !isLauncher
    }

    package static func tooltipAlignment(edge: BarEdge) -> Alignment {
        switch edge {
        case .bottom: .top
        case .top: .bottom
        case .leading: .trailing
        case .trailing: .leading
        }
    }

    package static func tooltipOffset(edge: BarEdge) -> CGSize {
        let travel = TaskbarMetrics.tooltipAllowance - TaskbarMetrics.tooltipGap
        switch edge {
        case .bottom: return CGSize(width: 0, height: -travel)
        case .top: return CGSize(width: 0, height: travel)
        case .leading: return CGSize(width: travel, height: 0)
        case .trailing: return CGSize(width: -travel, height: 0)
        }
    }
}
