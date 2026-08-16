import Testing
@testable import KcdBarTaskbar

struct ApplicationSearchTests {
    private func application(_ displayName: String) -> InstalledApplication {
        InstalledApplication(
            bundleIdentifier: "com.example.\(displayName.lowercased())",
            displayName: displayName,
            path: "/Applications/\(displayName).app"
        )
    }

    private var catalogue: [InstalledApplication] {
        [
            application("Activity Monitor"),
            application("Safari"),
            application("Disk Utility"),
            application("Mail"),
            application("Xcode")
        ]
    }

    @Test func anEmptyQueryIsEveryApplicationUntouched() {
        #expect(ApplicationSearch.matching("", in: catalogue).count == catalogue.count)
        #expect(ApplicationSearch.matching("   ", in: catalogue).count == catalogue.count)
    }

    @Test func aNameStartBeatsAWordStartWhichBeatsAMatchAnywhere() {
        let applications = [application("Disk Utility"), application("Photo Sketch"), application("Skype")]

        let found = ApplicationSearch.matching("sk", in: applications)

        #expect(found.map(\.displayName) == ["Skype", "Photo Sketch", "Disk Utility"])
    }

    @Test func caseAndAccentsAreIgnoredOnBothSides() {
        let applications = [application("Épargne"), application("SAFARI")]

        #expect(ApplicationSearch.matching("epa", in: applications).map(\.displayName) == ["Épargne"])
        #expect(ApplicationSearch.matching("safari", in: applications).map(\.displayName) == ["SAFARI"])
    }

    @Test func nothingMatchingIsAnEmptyResultRatherThanEverything() {
        #expect(ApplicationSearch.matching("zzz", in: catalogue).isEmpty)
    }

    @Test func equallyRankedMatchesKeepTheCataloguesOwnOrder() {
        let applications = [application("Mail Drop"), application("Mail")]

        let found = ApplicationSearch.matching("mail", in: applications)

        #expect(found.map(\.displayName) == ["Mail", "Mail Drop"])
    }

    @Test func aQueryIsTrimmedBeforeItIsMatched() {
        #expect(ApplicationSearch.matching("  safari  ", in: catalogue).map(\.displayName) == ["Safari"])
    }

    @Test func rankNamesTheThreeKindsOfMatch() {
        #expect(ApplicationSearch.rank(of: "Skype", against: "sk") == StartMenuMetrics.nameStartRank)
        #expect(ApplicationSearch.rank(of: "Photo Sketch", against: "sk") == StartMenuMetrics.wordStartRank)
        #expect(ApplicationSearch.rank(of: "Disk Utility", against: "sk") == StartMenuMetrics.anywhereRank)
        #expect(ApplicationSearch.rank(of: "Safari", against: "zzz") == nil)
    }
}
