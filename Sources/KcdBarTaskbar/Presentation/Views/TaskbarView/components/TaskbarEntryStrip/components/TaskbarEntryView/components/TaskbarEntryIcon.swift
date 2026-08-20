import SwiftUI

package struct TaskbarEntryIcon: View {
    package let icon: Image?
    package let size: CGFloat

    package var body: some View {
        Group {
            if let icon {
                icon.resizable().interpolation(.high)
            } else {
                Image(systemName: "app.dashed").resizable()
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(width: size, height: size)
    }
}
