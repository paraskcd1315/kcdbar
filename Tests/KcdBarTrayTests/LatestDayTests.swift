import Foundation
import Testing

@testable import KcdBarTray

struct LatestDayTests {
    private let epoch = Date(timeIntervalSince1970: 0)

    @Test func theFirstReadingIsAlwaysTaken() {
        var latest = LatestDay()
        let took = latest.accepts(epoch)

        #expect(took)
    }

    @Test func aNewerReadingReplacesTheOneBeforeIt() {
        var latest = LatestDay()

        _ = latest.accepts(epoch)
        let took = latest.accepts(epoch.addingTimeInterval(60))

        #expect(took)
    }

    @Test func aStaleChannelDoesNotOverwriteTheLiveOne() {
        var latest = LatestDay()

        _ = latest.accepts(epoch.addingTimeInterval(60))
        let took = latest.accepts(epoch)

        #expect(took == false)
    }

    @Test func theOrderTheChannelsArriveInDoesNotChangeTheWinner() {
        var forwards = LatestDay()
        var backwards = LatestDay()

        _ = forwards.accepts(epoch)
        let forwardsTookNewer = forwards.accepts(epoch.addingTimeInterval(60))

        _ = backwards.accepts(epoch.addingTimeInterval(60))
        let backwardsTookOlder = backwards.accepts(epoch)

        #expect(forwardsTookNewer)
        #expect(backwardsTookOlder == false)
    }
}
