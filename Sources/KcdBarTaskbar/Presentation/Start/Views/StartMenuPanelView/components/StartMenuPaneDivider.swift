import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPaneDivider: View {
    package var body: some View {
        Rectangle()
            .fill(KbColors.separator)
            .frame(width: KbEdgeMetrics.width)
    }
}
