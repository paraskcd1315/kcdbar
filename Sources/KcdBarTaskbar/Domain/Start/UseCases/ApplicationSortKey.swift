/** What a name sorts and bands as, once its invisible and leading special characters are ignored. */
package enum ApplicationSortKey {
    package static func of(_ displayName: String) -> String {
        let cleaned = ApplicationDisplayName.cleaned(displayName)
        guard let start = cleaned.firstIndex(where: { $0.isLetter || $0.isNumber }) else {
            return cleaned
        }

        return String(cleaned[start...])
    }
}
