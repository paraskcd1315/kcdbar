import Foundation
import Observation

/** The windows KCDBar minimized to show the desktop, so the same click can put them back. */
@MainActor
@Observable
final class ShowDesktopState {
    private(set) var hiddenKeys: [String] = []
    private(set) var systemShowingDesktop = false

    var isShowingDesktop: Bool { systemShowingDesktop || !hiddenKeys.isEmpty }

    func setSystemShowingDesktop(_ showing: Bool) {
        systemShowingDesktop = showing
    }

    func remember(keys: [String]) {
        hiddenKeys = keys
    }

    func clear() {
        hiddenKeys = []
    }
}
