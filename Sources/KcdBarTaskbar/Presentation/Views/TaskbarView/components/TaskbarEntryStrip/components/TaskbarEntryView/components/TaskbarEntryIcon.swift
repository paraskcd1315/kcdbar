import SwiftUI

package struct TaskbarEntryIcon: View {
    package let icon: Image?

    package var body: some View {
        Group {
            if let icon {
                icon.resizable().interpolation(.high)
            } else {
                Image(systemName: "app.dashed").resizable()
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(width: TaskbarMetrics.iconSize, height: TaskbarMetrics.iconSize)
    }
}
