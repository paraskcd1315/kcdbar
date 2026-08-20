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
