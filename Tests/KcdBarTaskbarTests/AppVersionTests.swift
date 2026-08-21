import Testing
@testable import KcdBarTaskbar

struct AppVersionTests {
    private func version(_ marketing: String) -> AppVersion {
        AppVersion(marketing: marketing, build: "219", commit: "da8d993")
    }

    @Test func theThreePartsAreMilestoneFeatureAndFix() {
        let parts = AppVersionComponents("2.4.7")

        #expect(parts?.milestone == 2)
        #expect(parts?.feature == 4)
        #expect(parts?.fix == 7)
    }

    @Test func aVersionThatIsNotThreeNumbersHasNoComponents() {
        #expect(AppVersionComponents("1.2") == nil)
        #expect(AppVersionComponents("1.2.3.4") == nil)
        #expect(AppVersionComponents("1.2.x") == nil)
        #expect(AppVersionComponents("") == nil)
        #expect(AppVersionComponents("0.0.-1") == nil)
    }

    @Test func aZeroMilestoneIsStillPrerelease() {
        #expect(version("0.0.1").isPrerelease)
        #expect(version("0.9.0").isPrerelease)
    }

    @Test func theFirstMilestoneEndsThePrerelease() {
        #expect(version("1.0.0").isPrerelease == false)
    }

    @Test func theKindIsTheDeepestPartThatIsSet() {
        #expect(AppVersionComponents("1.0.0")?.kind == .milestone)
        #expect(AppVersionComponents("1.2.0")?.kind == .feature)
        #expect(AppVersionComponents("1.2.3")?.kind == .fix)
        #expect(AppVersionComponents("0.0.1")?.kind == .fix)
    }

    @Test func theCommitTravelsWithTheVersion() {
        #expect(version("0.0.1").full == "0.0.1 (219) · da8d993")
    }

    @Test func aBuildWithNoCommitStillReads() {
        let unstamped = AppVersion(marketing: "0.0.1", build: "219", commit: "")

        #expect(unstamped.full == "0.0.1 (219)")
    }
}
