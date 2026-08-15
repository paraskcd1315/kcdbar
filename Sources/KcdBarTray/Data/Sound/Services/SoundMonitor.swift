import Observation

/** The control centre's live view of output volume. */
@MainActor
@Observable
package final class SoundMonitor {
    package private(set) var state: SoundState = .unavailable

    private let source: any SoundPort

    package init(source: any SoundPort) {
        self.source = source
    }

    package func refresh() {
        state = source.state()
    }

    package func setVolume(_ volume: Double) {
        source.setVolume(volume)
        if state.isMuted, volume > 0 {
            source.setMuted(false)
        }
        refresh()
    }

    package func toggleMuted() {
        source.setMuted(!state.isMuted)
        refresh()
    }
}
