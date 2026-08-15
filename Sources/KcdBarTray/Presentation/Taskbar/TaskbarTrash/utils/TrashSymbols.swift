/** Fallback glyphs for when AppKit has no trash icon to give. */
package enum TrashSymbols {
    package static func fallback(isEmpty: Bool) -> String {
        isEmpty ? "trash" : "trash.fill"
    }
}
