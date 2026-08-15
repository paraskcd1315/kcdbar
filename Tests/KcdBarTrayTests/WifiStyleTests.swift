import Testing

@testable import KcdBarTray

struct WifiStyleTests {
    private func state(available: Bool = true, powered: Bool = true, rssi: Int) -> WifiState {
        WifiState(isAvailable: available, isPowered: powered, ssid: "net", rssi: rssi)
    }

    @Test func theSlashOnlyMeansOff() {
        #expect(WifiStyle.symbol(for: state(powered: false, rssi: 0)) == WifiMetrics.slashSymbol)
        #expect(WifiStyle.symbol(for: state(available: false, rssi: 0)) == WifiMetrics.slashSymbol)
    }

    @Test func aPoweredRadioNeverDrawsTheSlash() {
        #expect(WifiStyle.symbol(for: state(rssi: 0)) == WifiMetrics.symbol)
        #expect(WifiStyle.symbol(for: state(rssi: -90)) == WifiMetrics.symbol)
        #expect(WifiStyle.symbol(for: state(rssi: -40)) == WifiMetrics.symbol)
    }

    @Test func theLevelFollowsTheSignal() {
        #expect(WifiStyle.level(rssi: -40) == 1)
        #expect(WifiStyle.level(rssi: -65) == WifiMetrics.fairLevel)
        #expect(WifiStyle.level(rssi: -75) == WifiMetrics.weakLevel)
        #expect(WifiStyle.level(rssi: -95) == WifiMetrics.faintLevel)
    }

    @Test func anUnmeasuredSignalReadsFullRatherThanEmpty() {
        #expect(WifiStyle.level(rssi: 0) == WifiMetrics.unknownLevel)
    }

    @Test func anUnpoweredRadioHasNoLevel() {
        #expect(WifiStyle.level(for: state(powered: false, rssi: -40)) == 0)
    }
}
