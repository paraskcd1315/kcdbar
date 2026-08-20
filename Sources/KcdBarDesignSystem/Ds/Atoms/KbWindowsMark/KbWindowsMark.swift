import SwiftUI

package struct KbWindowsMark: View {
    package let generation: KbWindowsGeneration
    package let size: CGFloat

    package init(generation: KbWindowsGeneration, size: CGFloat) {
        self.generation = generation
        self.size = size
    }

    package var body: some View {
        Group {
            switch generation {
            case .eleven: KbWindows11Shape().fill(KbGradients.mark)
            case .ten: KbWindows10Shape().fill(KbGradients.mark)
            }
        }
        .frame(width: size * KbWindowsMarkMetrics.widthRatio, height: size)
    }
}
