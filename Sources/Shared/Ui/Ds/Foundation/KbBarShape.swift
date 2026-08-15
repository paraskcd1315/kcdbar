import SwiftUI

enum KbBarShape {
    static func shape(edge: BarEdge, attachment: BarAttachment, cornerRadius: CGFloat) -> AnyShape {
        guard attachment == .edgeAttached else {
            return AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        return AnyShape(
            UnevenRoundedRectangle(
                topLeadingRadius: radius(cornerRadius, isRounded: edge != .top && edge != .leading),
                bottomLeadingRadius: radius(cornerRadius, isRounded: edge != .bottom && edge != .leading),
                bottomTrailingRadius: radius(cornerRadius, isRounded: edge != .bottom && edge != .trailing),
                topTrailingRadius: radius(cornerRadius, isRounded: edge != .top && edge != .trailing)
            )
        )
    }

    private static func radius(_ cornerRadius: CGFloat, isRounded: Bool) -> CGFloat {
        isRounded ? cornerRadius : 0
    }
}
