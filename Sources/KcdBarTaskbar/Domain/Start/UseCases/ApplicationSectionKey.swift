import Foundation

/** The heading an application sorts under — its first letter, or the digit band. */
package enum ApplicationSectionKey {
    package static func of(_ displayName: String) -> String {
        guard let first = displayName.first else { return StartMenuMetrics.otherSectionKey }
        let folded = String(first).folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: .current
        )
        guard let letter = folded.first, letter.isLetter else {
            return StartMenuMetrics.otherSectionKey
        }

        return letter.uppercased()
    }
}
