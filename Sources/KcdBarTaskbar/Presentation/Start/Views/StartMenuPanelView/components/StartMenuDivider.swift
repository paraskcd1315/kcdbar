import KcdBarDesignSystem
import SwiftUI

package struct StartMenuDivider: View {
    package var body: some View {
        Rectangle()
            .fill(KbColors.separator)
            .frame(height: KbPopoverMetrics.dividerHeight)
    }
}
