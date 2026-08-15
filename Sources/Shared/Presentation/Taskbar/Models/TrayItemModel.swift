import SwiftUI

struct TrayItemModel: Identifiable, Equatable {
    let id: String
    let applicationName: String
    let label: String?
    let icon: Image?
    let isGlyph: Bool

    static func == (lhs: TrayItemModel, rhs: TrayItemModel) -> Bool {
        lhs.id == rhs.id
            && lhs.applicationName == rhs.applicationName
            && lhs.label == rhs.label
            && lhs.isGlyph == rhs.isGlyph
    }
}
