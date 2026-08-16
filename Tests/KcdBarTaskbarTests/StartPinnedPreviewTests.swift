import Testing
@testable import KcdBarTaskbar

struct StartPinnedPreviewTests {
    private func band(_ id: String, _ identifiers: [String]) -> StartPinnedBand {
        StartPinnedBand(
            group: StartGroup(id: id, order: 0),
            applications: identifiers.map {
                InstalledApplication(bundleIdentifier: $0, displayName: $0, path: "")
            }
        )
    }

    @Test func theRehearsalShowsWhereTheTileWouldLand() {
        let preview = StartPinnedSections.previewing(
            [band("one", ["a", "b", "c"])],
            moving: "c",
            to: "one",
            before: "a"
        )

        #expect(preview.first?.applications.map(\.bundleIdentifier) == ["c", "a", "b"])
    }

    @Test func theRehearsalKeepsEveryBandItWasGiven() {
        let preview = StartPinnedSections.previewing(
            [band("one", ["a"]), band("two", [])],
            moving: "a",
            to: "two",
            before: nil
        )

        #expect(preview.map(\.group.id) == ["one", "two"])
        #expect(preview.first?.applications.isEmpty == true)
        #expect(preview.last?.applications.map(\.bundleIdentifier) == ["a"])
    }

    @Test func theRehearsalAndTheSavedOrderAgree() {
        let bands = [band("one", ["a", "b"]), band("two", ["c"])]
        let preview = StartPinnedSections.previewing(bands, moving: "a", to: "two", before: "c")
        let saved = StartPinnedSections.moved(bands, moving: "a", to: "two", before: "c")

        let previewed = preview.flatMap { band in
            band.applications.map { ($0.bundleIdentifier, band.group.id) }
        }
        let stored = saved
            .sorted { $0.order < $1.order }
            .map { ($0.bundleIdentifier, $0.groupId) }

        #expect(Set(previewed.map { "\($0.1)/\($0.0)" }) == Set(stored.map { "\($0.1)/\($0.0)" }))
    }
}
