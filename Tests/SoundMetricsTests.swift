import Testing

struct SoundMetricsTests {
    @Test func mutedWinsOverEveryVolume() {
        #expect(SoundMetrics.symbol(volume: 1, isMuted: true) == SoundMetrics.mutedSymbol)
        #expect(SoundMetrics.symbol(volume: 0, isMuted: true) == SoundMetrics.mutedSymbol)
    }

    @Test func silenceIsNotTheSameAsMuted() {
        #expect(SoundMetrics.symbol(volume: 0, isMuted: false) == SoundMetrics.quietSymbol)
    }

    @Test func theWavesFollowTheVolume() {
        #expect(SoundMetrics.symbol(volume: 0.3, isMuted: false) == SoundMetrics.mediumSymbol)
        #expect(SoundMetrics.symbol(volume: 0.5, isMuted: false) == SoundMetrics.mediumSymbol)
        #expect(SoundMetrics.symbol(volume: 0.51, isMuted: false) == SoundMetrics.loudSymbol)
        #expect(SoundMetrics.symbol(volume: 1, isMuted: false) == SoundMetrics.loudSymbol)
    }

    @Test func bluetoothSymbolFollowsPower() {
        #expect(BluetoothMetrics.symbol(isPowered: true) == BluetoothMetrics.onSymbol)
        #expect(BluetoothMetrics.symbol(isPowered: false) == BluetoothMetrics.offSymbol)
    }
}
