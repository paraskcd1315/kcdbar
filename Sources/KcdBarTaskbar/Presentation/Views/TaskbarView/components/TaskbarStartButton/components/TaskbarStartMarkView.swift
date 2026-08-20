import KcdBarDesignSystem
import SwiftUI

package struct TaskbarStartMarkView: View {
    package let mark: BarStartMark
    package let size: CGFloat

    package init(mark: BarStartMark, size: CGFloat) {
        self.mark = mark
        self.size = size
    }

    package var body: some View {
        switch mark {
        case .windows11:
            KbWindowsMark(generation: .eleven, size: markSize)
        case .windows10:
            KbWindowsMark(generation: .ten, size: markSize)
        case .bars, .apple, .grid, .power:
            Image(systemName: TaskbarStartMarkSymbol.name(for: mark))
                .font(.system(size: markSize, weight: .medium))
        }
    }

    private var markSize: CGFloat {
        size * BarEntryMetrics.markRatio
    }
}
