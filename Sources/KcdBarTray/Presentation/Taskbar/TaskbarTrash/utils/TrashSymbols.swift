/** Fallback glyphs for when AppKit has no trash icon to give. */
package enum TrashSymbols {
    package static let openSymbol = "folder"
    package static let emptySymbol = "trash.slash"

    package static func fallback(isEmpty: Bool) -> String {
        isEmpty ? "trash" : "trash.fill"
    }
}
