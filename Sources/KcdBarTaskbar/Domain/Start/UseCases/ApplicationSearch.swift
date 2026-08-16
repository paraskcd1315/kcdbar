import Foundation

/** Ranks the catalogue against what was typed — name start first, then word start, then anywhere. */
package enum ApplicationSearch {
    package static func matching(
        _ query: String,
        in applications: [InstalledApplication]
    ) -> [InstalledApplication] {
        let wanted = folded(query)
        guard !wanted.isEmpty else { return applications }

        let ranked = applications.compactMap { application -> (InstalledApplication, Int)? in
            guard let rank = rank(of: application.displayName, against: wanted) else { return nil }

            return (application, rank)
        }

        return ranked
            .sorted { left, right in
                guard left.1 == right.1 else { return left.1 < right.1 }

                return ApplicationCatalogue.sorted([left.0, right.0]).first == left.0
            }
            .map(\.0)
    }

    package static func rank(of displayName: String, against wanted: String) -> Int? {
        let name = folded(displayName)
        guard let found = name.range(of: wanted) else { return nil }
        guard found.lowerBound != name.startIndex else { return StartMenuMetrics.nameStartRank }

        let preceding = name[name.index(before: found.lowerBound)]
        guard preceding.isLetter || preceding.isNumber else { return StartMenuMetrics.wordStartRank }

        return StartMenuMetrics.anywhereRank
    }

    package static func folded(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
    }
}
