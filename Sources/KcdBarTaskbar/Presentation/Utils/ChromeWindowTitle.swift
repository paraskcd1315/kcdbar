import Foundation

/** Chrome titles a window `<page> - Google Chrome - <profile>` for Accessibility; the profile is the last part. */
package enum ChromeWindowTitle {
    package static let separator = " - Google Chrome - "

    package static func profile(of accessibilityTitle: String?) -> String? {
        guard let accessibilityTitle,
              let range = accessibilityTitle.range(of: separator, options: .backwards)
        else {
            return nil
        }
        let profile = accessibilityTitle[range.upperBound...].trimmingCharacters(in: .whitespaces)

        return profile.isEmpty ? nil : profile
    }
}
