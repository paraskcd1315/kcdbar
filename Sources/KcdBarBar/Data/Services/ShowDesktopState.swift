import Foundation
import Observation

/** The windows KCDBar minimized to show the desktop, so the same click can put them back. */
@MainActor
@Observable
package final class ShowDesktopState {
    package init() {}

    package private(set) var hiddenKeys: [String] = []
    package private(set) var systemShowingDesktop = false

    package var isShowingDesktop: Bool { systemShowingDesktop || !hiddenKeys.isEmpty }

    package func setSystemShowingDesktop(_ showing: Bool) {
        systemShowingDesktop = showing
    }

    package func remember(keys: [String]) {
        hiddenKeys = keys
    }

    package func clear() {
        hiddenKeys = []
    }
}
