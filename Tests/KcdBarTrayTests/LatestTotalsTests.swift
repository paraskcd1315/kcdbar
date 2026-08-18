import Foundation
import Testing

@testable import KcdBarTray

struct LatestTotalsTests {
    private let epoch = Date(timeIntervalSince1970: 0)

    @Test func theFirstReadingIsAlwaysTaken() {
        var latest = LatestTotals()
        let took = latest.accepts(epoch)

        #expect(took)
    }

    @Test func aNewerReadingReplacesTheOneBeforeIt() {
        var latest = LatestTotals()

        _ = latest.accepts(epoch)
        let took = latest.accepts(epoch.addingTimeInterval(60))

        #expect(took)
    }

    @Test func aStaleChannelDoesNotOverwriteTheLiveOne() {
        var latest = LatestTotals()

        _ = latest.accepts(epoch.addingTimeInterval(60))
        let took = latest.accepts(epoch)

        #expect(took == false)
    }

    @Test func theOrderTheChannelsArriveInDoesNotChangeTheWinner() {
        var forwards = LatestTotals()
        var backwards = LatestTotals()

        _ = forwards.accepts(epoch)
        let forwardsTookNewer = forwards.accepts(epoch.addingTimeInterval(60))

        _ = backwards.accepts(epoch.addingTimeInterval(60))
        let backwardsTookOlder = backwards.accepts(epoch)

        #expect(forwardsTookNewer)
        #expect(backwardsTookOlder == false)
    }
}
