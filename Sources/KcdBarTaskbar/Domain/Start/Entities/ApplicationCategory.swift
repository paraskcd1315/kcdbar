/** The band an application falls in when the Start menu groups by category. */
package enum ApplicationCategory: String, CaseIterable, Sendable {
    case productivity
    case creativity
    case developer
    case social
    case entertainment
    case utilities
    case reference
    case other

    package static func of(_ applicationCategoryType: String?) -> ApplicationCategory {
        guard let raw = applicationCategoryType else { return .other }
        let suffix = raw.replacingOccurrences(
            of: ApplicationCategoryMetrics.rawPrefix,
            with: ""
        )
        if let known = ApplicationCategoryMetrics.byRawSuffix[suffix] { return known }
        guard suffix.hasSuffix(ApplicationCategoryMetrics.gameSuffix) else { return .other }

        return .entertainment
    }

    package var titleKey: String { ApplicationCategoryMetrics.titlePrefix + rawValue }
}
