import CoreGraphics
import Observation

/** Where the bar is drawn inside its panel — the click-through margins and the rim both read it. */
@MainActor
@Observable
package final class BarFrameState {
    package var frame: CGRect?

    package init(frame: CGRect? = nil) {
        self.frame = frame
    }
}
