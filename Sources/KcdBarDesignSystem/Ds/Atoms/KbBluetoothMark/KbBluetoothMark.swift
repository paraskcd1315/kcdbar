import SwiftUI

package struct KbBluetoothMark: View {
    package let size: CGFloat

    package init(size: CGFloat) {
        self.size = size
    }

    package var body: some View {
        KbBluetoothShape()
            .stroke(
                style: StrokeStyle(
                    lineWidth: size * KbBluetoothMarkMetrics.strokeRatio,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .frame(width: size * KbBluetoothMarkMetrics.widthRatio, height: size)
    }
}
