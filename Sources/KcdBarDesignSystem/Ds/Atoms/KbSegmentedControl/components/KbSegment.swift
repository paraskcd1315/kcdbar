import SwiftUI

/** One choice in a segmented control — a label, a glyph, or both. */
package struct KbSegment<Value: Hashable>: Identifiable {
    package let value: Value
    package let titleKey: LocalizedStringKey?
    package let glyph: String?

    package init(value: Value, titleKey: LocalizedStringKey? = nil, glyph: String? = nil) {
        self.value = value
        self.titleKey = titleKey
        self.glyph = glyph
    }

    package var id: Value { value }
}
