import Testing
@testable import KcdBarTray

struct WifiScanReducerTests {
    private func network(_ ssid: String, _ rssi: Int) -> WifiNetwork {
        WifiNetwork(ssid: ssid, rssi: rssi, isSecure: true, isKnown: false, isCurrent: false)
    }

    @Test func oneSsidFromTwoAccessPointsKeepsTheStronger() {
        let reduced = WifiScanReducer.strongestPerSsid([
            network("mesh", -70),
            network("mesh", -45),
            network("mesh", -80),
        ])

        #expect(reduced.count == 1)
        #expect(reduced.first?.rssi == -45)
    }

    @Test func distinctSsidsAllSurvive() {
        let reduced = WifiScanReducer.strongestPerSsid([
            network("a", -50),
            network("b", -60),
        ])

        #expect(Set(reduced.map(\.ssid)) == ["a", "b"])
    }

    @Test func aHiddenNetworkWithNoNameIsDropped() {
        #expect(WifiScanReducer.strongestPerSsid([network("", -40)]).isEmpty)
    }
}
