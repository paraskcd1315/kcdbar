import KcdBarDesignSystem
import SwiftUI

package struct StartMenuIndexRail: View {
    package let keys: [String]
    package let available: Set<String>
    package let onSelect: (String) -> Void

    @State private var lastSent: String?

    package var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(keys, id: \.self) { key in
                    Text(key)
                        .font(.system(size: StartMenuMetrics.railLetterHeight, weight: .semibold))
                        .foregroundStyle(KbColors.onSurfaceMuted)
                        .opacity(available.contains(key) ? 1 : StartMenuMetrics.disabledLetterOpacity)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { send(at: $0.location.y, in: geometry.size.height) }
                    .onEnded { _ in lastSent = nil }
            )
        }
        .frame(width: StartMenuMetrics.railWidth)
    }

    private func send(at y: CGFloat, in height: CGFloat) {
        guard height > 0, !keys.isEmpty else { return }
        let index = Int(y / (height / CGFloat(keys.count)))
        guard keys.indices.contains(index) else { return }

        let key = keys[index]
        guard available.contains(key), key != lastSent else { return }

        lastSent = key
        onSelect(key)
    }
}
