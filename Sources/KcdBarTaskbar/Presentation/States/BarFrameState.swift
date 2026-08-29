import CoreGraphics
import Observation

/** Where the bar and its tooltip are drawn inside the panel — the click-through margins and the rim both read it. */
@MainActor
@Observable
package final class BarFrameState {
    package var frame: CGRect?
    package var tooltipFrame: CGRect?

    package init(frame: CGRect? = nil) {
        self.frame = frame
    }
}
