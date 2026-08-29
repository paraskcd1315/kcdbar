import KcdBarDesignSystem
import SwiftUI

package struct TaskbarEntryStack: View {
    package let side: CGFloat
    package let sheets: Int

    package var body: some View {
        ZStack {
            ForEach((0..<sheets).reversed(), id: \.self) { index in
                let sheet = index + 1
                RoundedRectangle(cornerRadius: TaskbarMetrics.stackCornerRadius)
                    .fill(KbColors.surfaceRaised.opacity(TaskbarMetrics.stackFillOpacity))
                    .overlay {
                        RoundedRectangle(cornerRadius: TaskbarMetrics.stackCornerRadius)
                            .strokeBorder(KbColors.onSurfaceMuted, lineWidth: TaskbarMetrics.separatorThickness)
                    }
                    .frame(width: sheetSide, height: sheetSide)
                    .offset(
                        x: TaskbarMetrics.stackStep * CGFloat(sheet),
                        y: -TaskbarMetrics.stackStep * CGFloat(sheet)
                    )
            }
        }
        .frame(width: side, height: side)
        .allowsHitTesting(false)
    }

    private var sheetSide: CGFloat {
        side - TaskbarMetrics.stackInset * 2
    }
}
