import Foundation
import Observation

/** The windows KCDBar minimized to show the desktop, so the same click can put them back. */
@MainActor
@Observable
final class ShowDesktopState {
    private(set) var hiddenKeys: [String] = []

    var isShowingDesktop: Bool { !hiddenKeys.isEmpty }

    func remember(keys: [String]) {
        hiddenKeys = keys
    }

    func clear() {
        hiddenKeys = []
    }
}
