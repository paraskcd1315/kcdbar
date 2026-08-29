// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/** Turns whatever the sources found into the one list the Start menu shows. */
package enum ApplicationCatalogue {
    package static func merged(_ found: [InstalledApplication]) -> [InstalledApplication] {
        var byIdentifier: [String: InstalledApplication] = [:]
        for application in found where byIdentifier[application.bundleIdentifier] == nil {
            byIdentifier[application.bundleIdentifier] = application
        }

        return sorted(Array(byIdentifier.values))
    }

    package static func sorted(_ applications: [InstalledApplication]) -> [InstalledApplication] {
        applications.sorted {
            let names = ApplicationSortKey.of($0.displayName)
                .localizedCaseInsensitiveCompare(ApplicationSortKey.of($1.displayName))
            guard names == .orderedSame else { return names == .orderedAscending }

            return $0.bundleIdentifier < $1.bundleIdentifier
        }
    }

    package static func sections(of applications: [InstalledApplication]) -> [ApplicationSection] {
        let grouped = Dictionary(grouping: applications) { ApplicationSectionKey.of($0.displayName) }

        return grouped.keys.sorted().map { key in
            ApplicationSection(key: key, applications: sorted(grouped[key] ?? []))
        }
    }

    package static func categorySections(
        of applications: [InstalledApplication]
    ) -> [ApplicationSection] {
        let grouped = Dictionary(grouping: applications, by: \.category)

        return ApplicationCategory.allCases.compactMap { category in
            guard let members = grouped[category], !members.isEmpty else { return nil }

            return ApplicationSection(
                key: category.rawValue,
                titleKey: category.titleKey,
                applications: sorted(members)
            )
        }
    }
}
