import Observation

/** The control centre's live view of output volume. */
@MainActor
@Observable
final class SoundMonitor {
    private(set) var state: SoundState = .unavailable

    private let source: any SoundPort

    init(source: any SoundPort) {
        self.source = source
    }

    func refresh() {
        state = source.state()
    }

    func setVolume(_ volume: Double) {
        source.setVolume(volume)
        if state.isMuted, volume > 0 {
            source.setMuted(false)
        }
        refresh()
    }

    func toggleMuted() {
        source.setMuted(!state.isMuted)
        refresh()
    }
}
