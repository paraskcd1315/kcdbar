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

struct StartMenuMetricsTests {
    @Test func noPinnedApplicationsTakeNoHeight() {
        #expect(StartMenuMetrics.pinnedHeight(0) == 0)
    }

    @Test func aPartLineOfPinsCostsAWholeLine() {
        #expect(StartMenuMetrics.pinnedHeight(1) == StartMenuMetrics.pinnedHeight(StartMenuMetrics.pinnedColumns))
    }

    @Test func oneMoreThanAFullLineAddsASecondLineAndItsSpacing() {
        let one = StartMenuMetrics.pinnedHeight(StartMenuMetrics.pinnedColumns)
        let two = StartMenuMetrics.pinnedHeight(StartMenuMetrics.pinnedColumns + 1)

        #expect(two == one + StartMenuMetrics.pinnedTileHeight + StartMenuMetrics.sectionSpacing)
    }

    @Test func anEmptyListStillReservesOneRow() {
        let empty = StartMenuMetrics.listHeight(rows: 0, sections: 0)
        let single = StartMenuMetrics.listHeight(rows: 1, sections: 0)

        #expect(empty == single)
    }

    @Test func everyBandCostsItsHeadingAndTheGapBetweenBands() {
        let one = StartMenuMetrics.listHeight(rows: 4, sections: 1)
        let two = StartMenuMetrics.listHeight(rows: 4, sections: 2)

        #expect(two == one + StartMenuMetrics.sectionHeadingHeight + StartMenuMetrics.sectionSpacing)
    }

    @Test func aShortMenuIsAsTallAsItsContent() {
        let height = StartMenuMetrics.bodyHeight(pinned: 0, rows: 1, sections: 1)

        #expect(height < StartMenuMetrics.bodyMaxHeight)
        #expect(height == StartMenuMetrics.listHeight(rows: 1, sections: 1))
    }

    @Test func aFullMachineIsClampedToTheBodyCeiling() {
        let height = StartMenuMetrics.bodyHeight(pinned: 12, rows: 240, sections: 24)

        #expect(height == StartMenuMetrics.bodyMaxHeight)
    }

    @Test func skeletonLabelWidthsCycleRatherThanRunOff() {
        let widths = StartMenuMetrics.skeletonLabelWidths

        #expect(StartMenuMetrics.skeletonLabelWidth(at: 0) == widths[0])
        #expect(StartMenuMetrics.skeletonLabelWidth(at: widths.count) == widths[0])
        #expect(StartMenuMetrics.skeletonLabelWidth(at: StartMenuMetrics.skeletonRowCount) == widths[StartMenuMetrics.skeletonRowCount % widths.count])
    }

    @Test func theSkeletonOpensABandOnItsFirstRowAndEveryBandLength() {
        #expect(StartMenuMetrics.skeletonStartsBand(at: 0))
        #expect(StartMenuMetrics.skeletonStartsBand(at: StartMenuMetrics.skeletonRowsPerBand))
        #expect(!StartMenuMetrics.skeletonStartsBand(at: 1))
    }

    @Test func theSkeletonCountsEveryBandItsRowsOpen() {
        let expected = (StartMenuMetrics.skeletonRowCount + StartMenuMetrics.skeletonRowsPerBand - 1)
            / StartMenuMetrics.skeletonRowsPerBand

        #expect(StartMenuMetrics.skeletonBandCount == expected)
        #expect((0..<StartMenuMetrics.skeletonRowCount).filter(StartMenuMetrics.skeletonStartsBand).count == expected)
    }
}
