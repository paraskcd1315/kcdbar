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

import Testing

@testable import KcdBarTaskbar

struct BarEntryMetricsTests {
    @Test func anIconTallerThanTheBarIsCappedSoTheContentPaddingStaysVisible() {
        var preset = BarPresetCatalogue.windows10
        preset.thickness = 40
        preset.contentPadding = 4
        preset.iconSize = 64

        #expect(BarEntryMetrics.iconSize(for: preset) == 32)
    }

    @Test func anIconThatFitsIsLeftAtTheSizeThePresetAsksFor() {
        var preset = BarPresetCatalogue.windows11
        preset.thickness = 48
        preset.contentPadding = 6
        preset.iconSize = 34

        #expect(BarEntryMetrics.iconSize(for: preset) == 34)
    }

    @Test func aBarTooThinForAnyIconStillDrawsOne() {
        var preset = BarPresetCatalogue.windows11
        preset.thickness = 16
        preset.contentPadding = 12
        preset.iconSize = 34

        #expect(BarEntryMetrics.iconSize(for: preset) == BarEntryMetrics.minimumIconSize)
    }

    @Test func everyShippedPresetLeavesItsContentPaddingVisible() {
        for preset in BarPresetCatalogue.all {
            let icon = BarEntryMetrics.iconSize(for: preset)

            #expect(icon + preset.contentPadding * 2 <= preset.thickness)
            #expect(icon == preset.iconSize)
        }
    }
}
