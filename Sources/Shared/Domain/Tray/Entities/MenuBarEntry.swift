import Foundation

/** One row of another application's menu bar menu. */
struct MenuBarEntry: Identifiable, Equatable, Sendable {
    let index: Int
    let title: String
    let isEnabled: Bool
    let hasSubmenu: Bool

    var id: Int { index }

    var isSeparator: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
