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

import SwiftUI

/** A thin track flanked by a small and a large glyph, in the shape macOS uses for display and sound. */
package struct KbSlider: View {
    package let value: Double
    package let leadingSymbol: String
    package let trailingSymbol: String
    package var trackHeight: CGFloat = KbSliderMetrics.trackHeight
    package let onChange: (Double) -> Void
    package let onTapLeading: () -> Void

    package init(
        value: Double,
        leadingSymbol: String,
        trailingSymbol: String,
        trackHeight: CGFloat = KbSliderMetrics.trackHeight,
        onChange: @escaping (Double) -> Void,
        onTapLeading: @escaping () -> Void
    ) {
        self.value = value
        self.leadingSymbol = leadingSymbol
        self.trailingSymbol = trailingSymbol
        self.trackHeight = trackHeight
        self.onChange = onChange
        self.onTapLeading = onTapLeading
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s4) {
            Image(systemName: leadingSymbol)
                .font(.system(size: KbSliderMetrics.leadingGlyphSize))
                .foregroundStyle(KbColors.onSurfaceMuted)
                .frame(width: KbSliderMetrics.leadingGlyphSize)
                .kbTappable(in: Rectangle(), perform: onTapLeading)
            KbSliderTrack(value: value, height: trackHeight, onChange: onChange)
            Image(systemName: trailingSymbol)
                .font(.system(size: KbSliderMetrics.trailingGlyphSize))
                .foregroundStyle(KbColors.onSurfaceMuted)
                .frame(width: KbSliderMetrics.trailingGlyphSize)
        }
    }
}
