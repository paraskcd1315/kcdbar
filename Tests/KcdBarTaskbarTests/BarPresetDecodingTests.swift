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
        #expect(preset.quitsOnLastWindow == BarPresetCatalogue.default.quitsOnLastWindow)
    }

    @Test func aStoredPresetFromBeforeTheQuitAxisQuitsOnLastWindowByDefault() throws {
        let payload = Data(#"{"name":"KCD copy","showsTrash":false}"#.utf8)

        let preset = try JSONDecoder().decode(BarPreset.self, from: payload)

        #expect(preset.quitsOnLastWindow)
        #expect(!preset.showsTrash)
    }

    @Test func aPayloadWithoutANameFails() throws {
        let payload = Data(#"{"iconSize":40}"#.utf8)

        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(BarPreset.self, from: payload)
        }
    }

    @Test func aPayloadFromBeforeTheStatusAreaSplitCarriesItsOneAnswerToEveryItem() throws {
        let hidden = Data(#"{"name":"stored","showsStatusArea":false}"#.utf8)

        let preset = try JSONDecoder().decode(BarPreset.self, from: hidden)

        #expect(!preset.showsBattery)
        #expect(!preset.showsControlCentre)
        #expect(!preset.showsClock)
        #expect(!preset.showsTracking)
        #expect(preset.showsTrash)
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
