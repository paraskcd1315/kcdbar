// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftUI

package enum KbBarShape {
    package static func shape(edge: BarEdge, attachment: BarAttachment, cornerRadius: CGFloat) -> AnyShape {
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

    package static func trailingCap(edge: BarEdge, attachment: BarAttachment, cornerRadius: CGFloat) -> AnyShape {
        guard attachment == .edgeAttached else {
            return AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        switch edge {
        case .bottom:
            return AnyShape(UnevenRoundedRectangle(topTrailingRadius: cornerRadius))
        case .top:
            return AnyShape(UnevenRoundedRectangle(bottomTrailingRadius: cornerRadius))
        case .leading:
            return AnyShape(UnevenRoundedRectangle(bottomTrailingRadius: cornerRadius))
        case .trailing:
            return AnyShape(UnevenRoundedRectangle(bottomLeadingRadius: cornerRadius))
        }
    }

    private static func radius(_ cornerRadius: CGFloat, isRounded: Bool) -> CGFloat {
        isRounded ? cornerRadius : 0
    }
}
