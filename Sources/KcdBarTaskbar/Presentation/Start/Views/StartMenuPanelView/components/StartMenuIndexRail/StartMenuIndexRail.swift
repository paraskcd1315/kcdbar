// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import KcdBarDesignSystem
import SwiftUI

package struct StartMenuIndexRail: View {
    package let keys: [String]
    package let available: Set<String>
    package let showsRecent: Bool
    package let onSelect: (String) -> Void

    @State private var lastSent: String?

    package var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if showsRecent {
                    Image(systemName: StartMenuMetrics.recentGlyph)
                        .font(.system(size: StartMenuMetrics.railLetterHeight, weight: .semibold))
                        .foregroundStyle(KbColors.onSurfaceMuted)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .kbTappable(in: Rectangle()) {
                            onSelect(StartMenuMetrics.recentSectionKey)
                        }
                }
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
        let slots = keys.count + (showsRecent ? 1 : 0)
        let index = Int(y / (height / CGFloat(slots))) - (showsRecent ? 1 : 0)
        guard keys.indices.contains(index) else { return }

        let key = keys[index]
        guard available.contains(key), key != lastSent else { return }

        lastSent = key
        onSelect(key)
    }
}
