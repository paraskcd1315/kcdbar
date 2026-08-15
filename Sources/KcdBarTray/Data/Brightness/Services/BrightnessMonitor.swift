import Observation

/** The control centre's live view of display brightness. */
@MainActor
@Observable
package final class BrightnessMonitor {
    package private(set) var state: BrightnessState = .unavailable

    private let source: any BrightnessPort

    package init(source: any BrightnessPort) {
        self.source = source
    }

    package func refresh() {
        state = source.state()
    }

    package func setLevel(_ level: Double) {
        source.setLevel(level)
        refresh()
    }
}
