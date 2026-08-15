import SwiftUI

struct KbBluetoothMark: View {
    let size: CGFloat

    var body: some View {
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
