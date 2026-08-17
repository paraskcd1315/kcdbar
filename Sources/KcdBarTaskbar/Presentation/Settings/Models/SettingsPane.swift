import SwiftUI

package enum SettingsPane: String, CaseIterable, Identifiable, Sendable {
    case appearance
    case behaviour

    package var id: String { rawValue }

    package var title: LocalizedStringKey { LocalizedStringKey("settings.pane.\(rawValue)") }

    package var detail: LocalizedStringKey { LocalizedStringKey("settings.pane.\(rawValue).detail") }

    package var symbol: String {
        switch self {
        case .appearance: "paintbrush"
        case .behaviour: "slider.horizontal.3"
        }
    }
}
