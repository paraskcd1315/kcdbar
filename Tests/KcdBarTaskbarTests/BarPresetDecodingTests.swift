import Foundation
import Testing

@testable import KcdBarTaskbar

struct BarPresetDecodingTests {
    @Test func aPayloadMissingEveryAxisButItsNameStillDecodes() throws {
        let payload = Data(#"{"name":"stored"}"#.utf8)

        let preset = try JSONDecoder().decode(BarPreset.self, from: payload)

        #expect(preset.name == "stored")
        #expect(preset.entryCornerRadius == BarPresetCatalogue.default.entryCornerRadius)
        #expect(preset.iconSize == BarPresetCatalogue.default.iconSize)
        #expect(preset.startMark == BarPresetCatalogue.default.startMark)
    }

    @Test func aPayloadWithoutANameFails() throws {
        let payload = Data(#"{"iconSize":40}"#.utf8)

        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(BarPreset.self, from: payload)
        }
    }

    @Test func everyAxisTheRoundTripCarriesSurvivesIt() throws {
        var edited = BarPresetCatalogue.dock
        edited.iconSize = 41
        edited.entryCornerRadius = 3

        let restored = try JSONDecoder().decode(
            BarPreset.self,
            from: JSONEncoder().encode(edited)
        )

        #expect(restored == edited)
    }
}
