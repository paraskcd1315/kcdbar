import Observation

/** The control centre's live view of display brightness. */
@MainActor
@Observable
final class BrightnessMonitor {
    private(set) var state: BrightnessState = .unavailable

    private let source: any BrightnessPort

    init(source: any BrightnessPort) {
        self.source = source
    }

    func refresh() {
        state = source.state()
    }

    func setLevel(_ level: Double) {
        source.setLevel(level)
        refresh()
    }
}
