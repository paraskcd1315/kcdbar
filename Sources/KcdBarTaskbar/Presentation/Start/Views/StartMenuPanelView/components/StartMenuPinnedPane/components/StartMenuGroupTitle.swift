import KcdBarDesignSystem
import SwiftUI

package struct StartMenuGroupTitle: View {
    package let group: StartGroup

    package var body: some View {
        Group {
            if let title = group.title {
                Text(title)
            } else if let titleKey = group.titleKey {
                Text(LocalizedStringKey(titleKey))
            } else {
                Text("start.group.untitled")
            }
        }
        .font(KbTypography.panelDetail)
        .foregroundStyle(KbColors.onSurfaceMuted)
        .lineLimit(1)
    }
}
