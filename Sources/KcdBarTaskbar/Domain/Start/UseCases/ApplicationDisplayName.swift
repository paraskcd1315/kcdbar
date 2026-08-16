import Foundation

/** The name as the user should read it, without the invisible marks bundles ship inside theirs. */
package enum ApplicationDisplayName {
    package static func cleaned(_ name: String) -> String {
        let visible = String(String.UnicodeScalarView(name.unicodeScalars.filter { !isInvisible($0) }))
        let trimmed = visible.trimmingCharacters(in: .whitespacesAndNewlines)

        return trimmed.isEmpty ? name : trimmed
    }

    private static func isInvisible(_ scalar: Unicode.Scalar) -> Bool {
        switch scalar.properties.generalCategory {
        case .format, .control, .lineSeparator, .paragraphSeparator: true
        default: false
        }
    }
}
