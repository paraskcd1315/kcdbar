import Observation

/** The preset the bar is currently drawn from. */
@MainActor
@Observable
package final class BarPresetState {
    package private(set) var preset: BarPreset

    package init(preset: BarPreset) {
        self.preset = preset
    }

    package func apply(_ preset: BarPreset) {
        self.preset = preset
    }
}
